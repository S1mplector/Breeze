import Foundation
import BreezeDomain
import BreezePorts

@MainActor
public final class JournalViewModel: ObservableObject {
    @Published public private(set) var entries: [JournalEntry] = []
    @Published public var selectedEntryID: UUID?
    @Published public var editorTitle: String = ""
    @Published public var editorBody: String = ""
    @Published public var statusMessage: String?

    private let useCase: any JournalUseCase
    private var autosaveTask: Task<Void, Never>?
    private var snapshotEntryID: UUID?
    private var snapshotTitle: String = ""
    private var snapshotBody: String = ""
    private let autosaveDelayNanoseconds: UInt64 = 650_000_000

    public init(useCase: any JournalUseCase) {
        self.useCase = useCase
    }

    public func load() {
        Task { await refresh() }
    }

    public func selectEntry(id: UUID?) {
        let previousID = selectedEntryID
        let previousTitle = editorTitle
        let previousBody = editorBody
        let wasDirty = isDirty

        cancelAutosave()
        selectedEntryID = id
        syncEditorWithSelection()

        guard let previousID, wasDirty else {
            return
        }

        Task { await persistEntry(id: previousID, title: previousTitle, body: previousBody) }
    }

    public func createNewEntry() {
        Task { await createEntry() }
    }

    public func saveEdits() {
        cancelAutosave()
        Task { await persistCurrentEntry() }
    }

    public func deleteSelected() {
        Task { await deleteEntry() }
    }

    public func editorDidChange() {
        guard selectedEntryID != nil else {
            return
        }

        if isDirty {
            scheduleAutosave()
        } else {
            cancelAutosave()
        }
    }

    private func refresh() async {
        do {
            entries = try await useCase.listEntries()
            syncEditorWithSelection()
            statusMessage = nil
        } catch {
            statusMessage = "Failed to load entries."
        }
    }

    private func syncEditorWithSelection() {
        guard let id = selectedEntryID,
              let entry = entries.first(where: { $0.id == id }) else {
            selectedEntryID = nil
            resetEditor()
            return
        }
        snapshotEntryID = id
        snapshotTitle = entry.title
        snapshotBody = entry.body
        editorTitle = entry.title
        editorBody = entry.body
    }

    private func createEntry() async {
        do {
            let entry = try await useCase.createEntry(title: "Untitled", body: "")
            entries = try await useCase.listEntries()
            selectedEntryID = entry.id
            syncEditorWithSelection()
            statusMessage = nil
        } catch {
            statusMessage = "Failed to create entry."
        }
    }

    private func persistCurrentEntry() async {
        guard let id = selectedEntryID else {
            return
        }
        await persistEntry(id: id, title: editorTitle, body: editorBody)
    }

    private func deleteEntry() async {
        guard let id = selectedEntryID else {
            return
        }
        do {
            try await useCase.deleteEntry(id: id)
            entries = try await useCase.listEntries()
            selectedEntryID = nil
            cancelAutosave()
            resetEditor()
            statusMessage = nil
        } catch {
            statusMessage = "Failed to delete entry."
        }
    }

    private var isDirty: Bool {
        guard let id = selectedEntryID, id == snapshotEntryID else {
            return false
        }
        return editorTitle != snapshotTitle || editorBody != snapshotBody
    }

    private func scheduleAutosave() {
        autosaveTask?.cancel()
        let queuedID = selectedEntryID
        let queuedTitle = editorTitle
        let queuedBody = editorBody
        let delay = autosaveDelayNanoseconds
        autosaveTask = Task { [weak self] in
            do {
                try await Task.sleep(nanoseconds: delay)
            } catch {
                return
            }
            await self?.persistIfCurrent(id: queuedID, title: queuedTitle, body: queuedBody)
        }
    }

    private func cancelAutosave() {
        autosaveTask?.cancel()
        autosaveTask = nil
    }

    private func persistEntry(id: UUID, title: String, body: String) async {
        do {
            _ = try await useCase.updateEntry(id: id, title: title, body: body)
            entries = try await useCase.listEntries()
            if selectedEntryID == id {
                snapshotEntryID = id
                snapshotTitle = title
                snapshotBody = body
            }
            statusMessage = nil
        } catch {
            statusMessage = "Failed to save entry."
        }
    }

    private func persistIfCurrent(id: UUID?, title: String, body: String) async {
        guard let id,
              selectedEntryID == id,
              editorTitle == title,
              editorBody == body,
              isDirty else {
            return
        }
        await persistEntry(id: id, title: title, body: body)
    }

    private func resetEditor() {
        snapshotEntryID = nil
        snapshotTitle = ""
        snapshotBody = ""
        editorTitle = ""
        editorBody = ""
    }
}
