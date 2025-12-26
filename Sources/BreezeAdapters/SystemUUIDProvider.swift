import Foundation
import BreezePorts

public struct SystemUUIDProvider: UUIDProviding {
    public init() {}

    public func next() -> UUID {
        UUID()
    }
}
