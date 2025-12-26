import SwiftUI

public struct JournalEditorView: View {
    @Binding private var title: String
    @Binding private var entryBody: String
    private let onSave: () -> Void
    private let onEdit: () -> Void
    @FocusState private var isBodyFocused: Bool

    public init(
        title: Binding<String>,
        entryBody: Binding<String>,
        onSave: @escaping () -> Void,
        onEdit: @escaping () -> Void
    ) {
        self._title = title
        self._entryBody = entryBody
        self.onSave = onSave
        self.onEdit = onEdit
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header
            Rectangle()
                .fill(BreezeTheme.divider)
                .frame(height: 1)
                .padding(.bottom, 4)
            bodyEditor
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 22)
        .padding(.vertical, 18)
        .onAppear { isBodyFocused = true }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            TextField("Title", text: $title, axis: .horizontal)
                .font(BreezeTheme.titleFont)
                .foregroundStyle(BreezeTheme.ink)
                .textFieldStyle(.plain)
                .onChange(of: title) { _ in onEdit() }
                .onSubmit { onSave() }

            Spacer()

            Button(action: onSave) {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark")
                    Text("Save")
                }
                .font(BreezeTheme.metaFont)
                .foregroundStyle(BreezeTheme.ink)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(BreezeTheme.controlFill)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(BreezeTheme.divider, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
            .keyboardShortcut("s", modifiers: [.command])
        }
        .padding(.bottom, 14)
    }

    private var bodyEditor: some View {
        TextEditor(text: $entryBody)
            .font(BreezeTheme.bodyFont)
            .foregroundStyle(BreezeTheme.ink)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .focused($isBodyFocused)
            .onChange(of: entryBody) { _ in onEdit() }
            .onTapGesture { isBodyFocused = true }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
