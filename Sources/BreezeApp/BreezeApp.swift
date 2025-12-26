import SwiftUI
import BreezeUI

@main
struct BreezeApp: App {
    @StateObject private var viewModel: JournalViewModel

    init() {
        let useCase = CompositionRoot.makeJournalUseCase()
        _viewModel = StateObject(wrappedValue: JournalViewModel(useCase: useCase))
    }

    var body: some Scene {
        WindowGroup {
            JournalView(viewModel: viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
