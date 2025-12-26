import Foundation
import BreezeDomain
import BreezePorts

public final class JournalService: JournalUseCase {
    private let repository: any JournalEntryRepository
    private let clock: any Clock
    private let uuidProvider: any UUIDProviding

    public init(
        repository: any JournalEntryRepository,
        clock: any Clock,
        uuidProvider: any UUIDProviding
    ) {
        self.repository = repository
        self.clock = clock
        self.uuidProvider = uuidProvider
    }

    public func listEntries() async throws -> [JournalEntry] {
        let entries = try await repository.fetchAll()
        return entries.sorted { $0.updatedAt > $1.updatedAt }
    }

    public func createEntry(title: String, body: String) async throws -> JournalEntry {
        let now = clock.now()
        let entry = JournalEntry(
            id: uuidProvider.next(),
            title: title,
            body: body,
            createdAt: now,
            updatedAt: now
        )
        try await repository.upsert(entry)
        return entry
    }

    public func updateEntry(id: UUID, title: String, body: String) async throws -> JournalEntry {
        let entries = try await repository.fetchAll()
        guard let existing = entries.first(where: { $0.id == id }) else {
            throw JournalError.entryNotFound
        }
        let updated = existing.updating(title: title, body: body, updatedAt: clock.now())
        try await repository.upsert(updated)
        return updated
    }

    public func deleteEntry(id: UUID) async throws {
        try await repository.delete(id: id)
    }
}
