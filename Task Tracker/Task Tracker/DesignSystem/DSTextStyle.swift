import UIKit

enum DSTextStyle {
    case largeTitle
    case title
    case body
    case bodyMedium
    case button
    case caption
    case captionMedium
    case small
}

extension UILabel {
    func apply(_ style: DSTextStyle, color: UIColor = DS.Colors.textPrimary) {
        textColor = color
        switch style {
        case .largeTitle:   font = DS.Typography.largeTitle()
        case .title:        font = DS.Typography.title()
        case .body:         font = DS.Typography.body()
        case .bodyMedium:   font = DS.Typography.bodyMedium()
        case .button:       font = DS.Typography.button()
        case .caption:      font = DS.Typography.caption()
        case .captionMedium: font = DS.Typography.captionMedium()
        case .small:        font = DS.Typography.small()
        }
    }
}
