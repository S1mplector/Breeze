import SwiftUI

enum BreezeTheme {
    static let sidebarGradient = LinearGradient(
        colors: [
            Color(red: 0.12, green: 0.12, blue: 0.13),
            Color(red: 0.09, green: 0.09, blue: 0.1)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let editorGradient = LinearGradient(
        colors: [
            Color(red: 0.16, green: 0.16, blue: 0.17),
            Color(red: 0.1, green: 0.1, blue: 0.11)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let editorSurface = Color(red: 0.14, green: 0.14, blue: 0.15)
    static let divider = Color(red: 0.25, green: 0.25, blue: 0.26)
    static let shadow = Color.black.opacity(0.45)
    static let accent = Color(red: 0.78, green: 0.76, blue: 0.71)
    static let ink = Color(red: 0.93, green: 0.92, blue: 0.9)
    static let inkSecondary = Color(red: 0.67, green: 0.66, blue: 0.63)
    static let placeholder = Color(red: 0.53, green: 0.52, blue: 0.5)
    static let controlFill = Color(red: 0.2, green: 0.2, blue: 0.21)
    static let controlHover = Color(red: 0.26, green: 0.26, blue: 0.27)

    static let appTitleFont = Font.custom("Avenir Next", size: 15).weight(.semibold)
    static let titleFont = Font.custom("Baskerville", size: 26).weight(.semibold)
    static let bodyFont = Font.custom("Baskerville", size: 17)
    static let listTitleFont = Font.custom("Avenir Next", size: 13).weight(.semibold)
    static let listBodyFont = Font.custom("Avenir Next", size: 11)
    static let metaFont = Font.custom("Avenir Next", size: 10).weight(.medium)
}
