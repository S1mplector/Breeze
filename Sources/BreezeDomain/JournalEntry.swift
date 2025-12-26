import Foundation

public struct JournalEntry: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public var title: String
    public var body: String
    public let createdAt: Date
    public var updatedAt: Date

    public init(id: UUID, title: String, body: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    public func updating(title: String, body: String, updatedAt: Date) -> JournalEntry {
        JournalEntry(
            id: id,
            title: title,
            body: body,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
