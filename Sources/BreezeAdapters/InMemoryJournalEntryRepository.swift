import Foundation
import BreezeDomain
import BreezePorts

public actor InMemoryJournalEntryRepository: JournalEntryRepository {
    private var entries: [JournalEntry]

    public init(seed: [JournalEntry] = []) {
        self.entries = seed
    }

    public func fetchAll() async throws -> [JournalEntry] {
        entries
    }

    public func upsert(_ entry: JournalEntry) async throws {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        } else {
            entries.append(entry)
        }
    }

    public func delete(id: UUID) async throws {
        entries.removeAll { $0.id == id }
    }
}
