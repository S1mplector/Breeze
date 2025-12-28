import SwiftUI
import BreezeDomain

public struct JournalView: View {
    @StateObject private var viewModel: JournalViewModel

    public init(viewModel: JournalViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detail
        }
        .accentColor(BreezeTheme.accent)
        .onAppear {
            viewModel.load()
        }
    }

    private var sidebar: some View {
        VStack(spacing: 0) {
            SidebarHeader(
                hasSelection: viewModel.selectedEntryID != nil,
                onCreate: viewModel.createNewEntry,
                onDelete: viewModel.deleteSelected
            )

            List(selection: selectionBinding) {
                ForEach(viewModel.entries) { entry in
                    JournalRowView(entry: entry)
                        .tag(entry.id)
                        .listRowInsets(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .animation(.easeInOut(duration: 0.2), value: viewModel.entries)

            if let message = viewModel.statusMessage {
                Text(message)
                    .font(BreezeTheme.metaFont)
                    .foregroundStyle(BreezeTheme.inkSecondary)
                    .padding(.top, 6)
            }
        }
        .padding(16)
        .background(BreezeTheme.sidebarGradient)
        .frame(minWidth: 250)
    }

    private var detail: some View {
        ZStack {
            BreezeTheme.editorGradient
                .ignoresSafeArea()
                .allowsHitTesting(false)

            if viewModel.selectedEntryID == nil {
                EmptyStateView()
            } else {
                JournalEditorView(
                    title: $viewModel.editorTitle,
                    entryBody: $viewModel.editorBody,
                    onSave: viewModel.saveEdits,
                    onEdit: viewModel.editorDidChange
                )
                .transition(.opacity)
            }
        }
    }

    private var selectionBinding: Binding<UUID?> {
        Binding(
            get: { viewModel.selectedEntryID },
            set: { viewModel.selectEntry(id: $0) }
        )
    }
}

private struct SidebarHeader: View {
    let hasSelection: Bool
    let onCreate: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text("Breeze")
                .font(BreezeTheme.appTitleFont)
                .foregroundStyle(BreezeTheme.ink)

            Spacer()

            SidebarIconButton(
                systemImage: "square.and.pencil",
                help: "New entry",
                action: onCreate
            )

            SidebarIconButton(
                systemImage: "trash",
                help: "Delete entry",
                isDisabled: !hasSelection,
                action: onDelete
            )
        }
        .padding(.bottom, 6)
    }
}

private struct SidebarIconButton: View {
    let systemImage: String
    let help: String
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(BreezeTheme.ink)
                .padding(8)
                .background(BreezeTheme.controlFill)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(BreezeTheme.divider, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .help(help)
        .opacity(isDisabled ? 0.4 : 1)
    }
}

private struct JournalRowView: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.title.isEmpty ? "Untitled" : entry.title)
                .font(BreezeTheme.listTitleFont)
                .foregroundStyle(BreezeTheme.ink)

            Text(entry.body.isEmpty ? "No content yet" : entry.body)
                .font(BreezeTheme.listBodyFont)
                .foregroundStyle(BreezeTheme.inkSecondary)
                .lineLimit(1)

            Text(entry.updatedAt, format: .dateTime.month().day())
                .font(BreezeTheme.metaFont)
                .foregroundStyle(BreezeTheme.inkSecondary)
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("A quiet place for your thoughts")
                .font(BreezeTheme.titleFont)
                .foregroundStyle(BreezeTheme.ink)

            Text("Create a new entry to begin.")
                .font(BreezeTheme.bodyFont)
                .foregroundStyle(BreezeTheme.inkSecondary)
        }
        .frame(maxWidth: 360)
    }
}
