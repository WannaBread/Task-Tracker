import UIKit

final class BDUIScreenRouter: BDUIScreenRoutingLogic {
    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
