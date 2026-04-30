import UIKit

final class BDUIScreenViewController: UIViewController {
    var interactor: BDUIScreenBusinessLogic?
    var router: BDUIScreenRoutingLogic?

    // MARK: - View

    private var bduiView: BDUIScreenView {
        view as! BDUIScreenView
    }

    override func loadView() {
        view = BDUIScreenView(delegate: self)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.loadScreen(request: BDUIScreen.Load.Request())
    }
}

// MARK: - BDUIScreenDisplayLogic

extension BDUIScreenViewController: BDUIScreenDisplayLogic {

    func display(viewModel: BDUIScreen.Load.ViewModel) {
        switch viewModel {
        case .loading:
            bduiView.showLoading()
        case .content(let rootView):
            bduiView.showContent(rootView: rootView)
        case .error(let message):
            bduiView.showError(message: message)
        }
    }

    func triggerReload() {
        interactor?.loadScreen(request: BDUIScreen.Load.Request())
    }
}

// MARK: - BDUIScreenViewDelegate

extension BDUIScreenViewController: BDUIScreenViewDelegate {

    func bduiScreenViewDidTapRetry() {
        interactor?.loadScreen(request: BDUIScreen.Load.Request())
    }
}
