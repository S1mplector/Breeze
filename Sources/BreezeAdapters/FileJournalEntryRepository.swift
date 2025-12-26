import Foundation
import BreezeDomain
import BreezePorts

public actor FileJournalEntryRepository: JournalEntryRepository {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(baseURL: URL? = nil, fileName: String = "entries.json") throws {
        let baseDirectory: URL
        if let baseURL = baseURL {
            baseDirectory = baseURL
        } else {
            baseDirectory = try FileManager.default
                .url(
                    for: .applicationSupportDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                )
                .appendingPathComponent("Breeze", isDirectory: true)
        }

        try FileManager.default.createDirectory(
            at: baseDirectory,
            withIntermediateDirectories: true
        )

        self.fileURL = baseDirectory.appendingPathComponent(fileName)
        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder.dateEncodingStrategy = .iso8601

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    public func fetchAll() async throws -> [JournalEntry] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([JournalEntry].self, from: data)
    }

    public func upsert(_ entry: JournalEntry) async throws {
        var entries = try await fetchAll()
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        } else {
            entries.append(entry)
        }
        try persist(entries)
    }

    public func delete(id: UUID) async throws {
        var entries = try await fetchAll()
        entries.removeAll { $0.id == id }
        try persist(entries)
    }

    private func persist(_ entries: [JournalEntry]) throws {
        let data = try encoder.encode(entries)
        try data.write(to: fileURL, options: [.atomic])
    }
}
