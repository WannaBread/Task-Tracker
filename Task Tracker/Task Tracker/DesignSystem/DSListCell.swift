import UIKit

struct TaskCellViewModel {
    let title: String
    let titleColor: UIColor
    let subtitle: String
    let icons: [IconConfig]

    struct IconConfig {
        let image: UIImage
        let tintColor: UIColor
    }
}
