import SwiftUI

public struct JournalEditorView: View {
    @Binding private var title: String
    @Binding private var entryBody: String
    private let onSave: () -> Void
    private let onEdit: () -> Void

    enum Field: Hashable {
        case title
        case body
    }
    @FocusState private var focusedField: Field?

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
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            TextField("Title", text: $title)
                .font(BreezeTheme.titleFont)
                .foregroundStyle(BreezeTheme.ink)
                .textFieldStyle(.roundedBorder)
                .focused($focusedField, equals: .title)
                .onChange(of: title) { _ in onEdit() }
                .onSubmit {
                    focusedField = .body
                }

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
            .focused($focusedField, equals: .body)
            .onChange(of: entryBody) { _ in onEdit() }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
