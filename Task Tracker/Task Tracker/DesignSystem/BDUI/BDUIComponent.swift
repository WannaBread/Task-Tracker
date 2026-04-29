import UIKit

// MARK: - Spacing Token

enum BDUISpacingToken: String, Decodable {
    case xs, s, m, l, xl

    var cgFloat: CGFloat {
        switch self {
        case .xs: return DS.Spacing.xs
        case .s:  return DS.Spacing.s
        case .m:  return DS.Spacing.m
        case .l:  return DS.Spacing.l
        case .xl: return DS.Spacing.xl
        }
    }
}

// MARK: - Color Token

enum BDUIColorToken: String, Decodable {
    case primary
    case textPrimary
    case textSecondary
    case background
    case error
    case success
    case warning

    var uiColor: UIColor {
        switch self {
        case .primary:        return DS.Colors.primary
        case .textPrimary:    return DS.Colors.textPrimary
        case .textSecondary:  return DS.Colors.textSecondary
        case .background:     return DS.Colors.background
        case .error:          return DS.Colors.error
        case .success:        return DS.Colors.success
        case .warning:        return DS.Colors.warning
        }
    }
}

// MARK: - Text Style Token

enum BDUITextStyleToken: String, Decodable {
    case largeTitle, title, body, bodyMedium, button, caption, captionMedium, small

    var dsTextStyle: DSTextStyle {
        switch self {
        case .largeTitle:    return .largeTitle
        case .title:         return .title
        case .body:          return .body
        case .bodyMedium:    return .bodyMedium
        case .button:        return .button
        case .caption:       return .caption
        case .captionMedium: return .captionMedium
        case .small:         return .small
        }
    }
}

// MARK: - Button Style Token

enum BDUIButtonStyleToken: String, Decodable {
    case primary, secondary, destructive

    var dsButtonStyle: DSButtonConfig.Style {
        switch self {
        case .primary:     return .primary
        case .secondary:   return .secondary
        case .destructive: return .destructive
        }
    }
}

// MARK: - Action

enum BDUIAction: Decodable {
    case reload

    private enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "reload":
            self = .reload
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown action type: \(type)"
            )
        }
    }
}

// MARK: - Padding

struct BDUIPadding: Decodable {
    let top: BDUISpacingToken?
    let bottom: BDUISpacingToken?
    let leading: BDUISpacingToken?
    let trailing: BDUISpacingToken?
}

// MARK: - Component Payloads

struct BDUIStackViewPayload: Decodable {
    enum Axis: String, Decodable {
        case horizontal, vertical
    }

    enum Alignment: String, Decodable {
        case fill, center, leading, trailing
    }

    let axis: Axis
    let spacing: BDUISpacingToken?
    let alignment: Alignment?
    let padding: BDUIPadding?
    let children: [BDUIComponent]
}

struct BDUILabelPayload: Decodable {
    let text: String
    let style: BDUITextStyleToken?
    let color: BDUIColorToken?
    let numberOfLines: Int?
    let padding: BDUIPadding?
}

struct BDUIButtonPayload: Decodable {
    let title: String
    let style: BDUIButtonStyleToken?
    let action: BDUIAction
    let padding: BDUIPadding?
}

struct BDUITextFieldPayload: Decodable {
    let title: String?
    let placeholder: String
    let isSecure: Bool?
    let padding: BDUIPadding?
}

struct BDUIImageViewPayload: Decodable {
    let systemName: String
    let tintColor: BDUIColorToken?
    let size: CGFloat?
    let padding: BDUIPadding?
}

// MARK: - BDUIComponent

enum BDUIComponent: Decodable {
    case stackView(BDUIStackViewPayload)
    case label(BDUILabelPayload)
    case button(BDUIButtonPayload)
    case textField(BDUITextFieldPayload)
    case imageView(BDUIImageViewPayload)

    var padding: BDUIPadding? {
        switch self {
        case .stackView(let p):   return p.padding
        case .label(let p):       return p.padding
        case .button(let p):      return p.padding
        case .textField(let p):   return p.padding
        case .imageView(let p):   return p.padding
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "stackView":
            self = .stackView(try BDUIStackViewPayload(from: decoder))
        case "label":
            self = .label(try BDUILabelPayload(from: decoder))
        case "button":
            self = .button(try BDUIButtonPayload(from: decoder))
        case "textField":
            self = .textField(try BDUITextFieldPayload(from: decoder))
        case "imageView":
            self = .imageView(try BDUIImageViewPayload(from: decoder))
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown component type: \(type)"
            )
        }
    }
}
