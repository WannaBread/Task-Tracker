import UIKit

// MARK: - BDUIScreen Data Flow

enum BDUIScreen {
    enum Load {
        struct Request {}

        struct Response {
            let component: BDUIComponent
        }

        enum ViewModel {
            case loading
            case content(rootView: UIView)
            case error(message: String)
        }
    }
}
