import UIKit

protocol DSThemeProtocol {
    var background: UIColor { get }
    var secondaryBackground: UIColor { get }
    var primary: UIColor { get }
    var error: UIColor { get }
    var success: UIColor { get }
    var warning: UIColor { get }
    var textPrimary: UIColor { get }
    var textSecondary: UIColor { get }
    var buttonText: UIColor { get }
    var fieldBorder: UIColor { get }
    var iconDefault: UIColor { get }
}

struct LightTheme: DSThemeProtocol {
    let background = UIColor.white
    let secondaryBackground = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
    let primary = UIColor.systemBlue
    let error = UIColor.systemRed
    let success = UIColor.systemGreen
    let warning = UIColor.systemOrange
    let textPrimary = UIColor.black
    let textSecondary = UIColor.darkGray
    let buttonText = UIColor.white
    let fieldBorder = UIColor.separator
    let iconDefault = UIColor.systemGray3
}

struct DarkTheme: DSThemeProtocol {
    let background = UIColor.black
    let secondaryBackground = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1)
    let primary = UIColor(red: 0.4, green: 0.61, blue: 1.0, alpha: 1)
    let error = UIColor(red: 1.0, green: 0.45, blue: 0.45, alpha: 1)
    let success = UIColor(red: 0.35, green: 0.85, blue: 0.45, alpha: 1)
    let warning = UIColor(red: 1.0, green: 0.75, blue: 0.3, alpha: 1)
    let textPrimary = UIColor.white
    let textSecondary = UIColor.lightGray
    let buttonText = UIColor.white
    let fieldBorder = UIColor(white: 0.3, alpha: 1)
    let iconDefault = UIColor.systemGray
}
