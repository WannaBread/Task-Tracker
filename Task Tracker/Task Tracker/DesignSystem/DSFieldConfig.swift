import UIKit

struct DSFieldConfig {
    let title: String
    let placeholder: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: UITextAutocapitalizationType = .sentences
    var autocorrection: UITextAutocorrectionType = .default
    var returnKeyType: UIReturnKeyType = .default
}
