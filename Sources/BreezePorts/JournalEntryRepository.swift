import Foundation
import BreezeDomain

public protocol JournalEntryRepository: Sendable {
    func fetchAll() async throws -> [JournalEntry]
    func upsert(_ entry: JournalEntry) async throws
    func delete(id: UUID) async throws
}
