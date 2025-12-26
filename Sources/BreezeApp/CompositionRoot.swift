import BreezeAdapters
import BreezeApplication
import BreezePorts

enum CompositionRoot {
    static func makeJournalUseCase() -> any JournalUseCase {
        let repository: any JournalEntryRepository
        do {
            repository = try FileJournalEntryRepository()
        } catch {
            repository = InMemoryJournalEntryRepository()
        }

        return JournalService(
            repository: repository,
            clock: SystemClock(),
            uuidProvider: SystemUUIDProvider()
        )
    }
}
