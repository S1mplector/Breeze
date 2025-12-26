import Foundation
import BreezeDomain

public protocol JournalUseCase: Sendable {
    func listEntries() async throws -> [JournalEntry]
    func createEntry(title: String, body: String) async throws -> JournalEntry
    func updateEntry(id: UUID, title: String, body: String) async throws -> JournalEntry
    func deleteEntry(id: UUID) async throws
}
