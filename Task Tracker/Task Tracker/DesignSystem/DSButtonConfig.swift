import UIKit

struct DSButtonConfig {
    enum Style {
        case primary
        case secondary
        case destructive
    }

    let title: String
    let style: Style
    var icon: UIImage? = nil
    var isEnabled: Bool = true
    var isLoading: Bool = false
}
