import Foundation

public protocol UUIDProviding: Sendable {
    func next() -> UUID
}
