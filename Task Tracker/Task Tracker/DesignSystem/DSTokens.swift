import UIKit

enum DS {

    // MARK: - Colors
    enum Colors {
        private static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
            UIColor { $0.userInterfaceStyle == .dark ? dark : light }
        }

        private static let light = LightTheme()
        private static let dark = DarkTheme()

        static let background        = dynamic(light: light.background,           dark: dark.background)
        static let secondaryBackground = dynamic(light: light.secondaryBackground, dark: dark.secondaryBackground)
        static let primary           = dynamic(light: light.primary,              dark: dark.primary)
        static let error             = dynamic(light: light.error,                dark: dark.error)
        static let success           = dynamic(light: light.success,              dark: dark.success)
        static let warning           = dynamic(light: light.warning,              dark: dark.warning)
        static let textPrimary       = dynamic(light: light.textPrimary,          dark: dark.textPrimary)
        static let textSecondary     = dynamic(light: light.textSecondary,        dark: dark.textSecondary)
        static let buttonText        = dynamic(light: light.buttonText,           dark: dark.buttonText)
        static let fieldBorder       = dynamic(light: light.fieldBorder,          dark: dark.fieldBorder)
        static let iconDefault       = dynamic(light: light.iconDefault,          dark: dark.iconDefault)
    }

    // MARK: - Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
        static let xl: CGFloat = 40
        static let cornerRadius: CGFloat = 12
        static let fieldHeight: CGFloat = 50
        static let buttonHeight: CGFloat = 50
        static let borderWidth: CGFloat = 1.5
        static let pageTopOffset: CGFloat = 240
    }

    // MARK: - Cell
    enum Cell {
        static let verticalPadding: CGFloat = 12
        static let textStackSpacing: CGFloat = 2
        static let horizontalMargin: CGFloat = 32
        static let estimatedRowHeight: CGFloat = 64
        static let iconSize: CGFloat = 20
        static let smallIconSize: CGFloat = 16
        static let rightStackMaxWidth: CGFloat = 110
    }

    // MARK: - StateView
    enum StateView {
        static let maxImageSize: CGFloat = 80
    }

    // MARK: - Animation
    enum Animation {
        static let debounceDelay: TimeInterval = 0.4
        static let keyboardFallbackDuration: TimeInterval = 0.25
        static let tapDuration: TimeInterval = 0.1
        static let tapAlpha: CGFloat = 0.7
        static let disabledAlpha: CGFloat = 0.5
        static let fullAlpha: CGFloat = 1.0
    }

    // MARK: - Button
    enum Button {
        static let secondaryBorderWidth: CGFloat = 1
        static let noBorderWidth: CGFloat = 0
    }

    // MARK: - Typography
    enum Typography {
        static func largeTitle() -> UIFont { .systemFont(ofSize: 32, weight: .bold) }
        static func title() -> UIFont { .systemFont(ofSize: 20, weight: .semibold) }
        static func body() -> UIFont { .systemFont(ofSize: 16, weight: .regular) }
        static func bodyMedium() -> UIFont { .systemFont(ofSize: 16, weight: .semibold) }
        static func button() -> UIFont { .systemFont(ofSize: 17, weight: .semibold) }
        static func caption() -> UIFont { .systemFont(ofSize: 14, weight: .regular) }
        static func captionMedium() -> UIFont { .systemFont(ofSize: 14, weight: .medium) }
        static func small() -> UIFont { .systemFont(ofSize: 13, weight: .regular) }
    }
}
