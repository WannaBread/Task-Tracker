import UIKit

final class BDUIScreenPresenter: BDUIScreenPresentationLogic {
    weak var viewController: BDUIScreenDisplayLogic?

    private let mapper: BDUIMapperProtocol = BDUIMapper()

    // MARK: - BDUIScreenPresentationLogic

    func presentLoading() {
        viewController?.display(viewModel: .loading)
    }

    func presentScreen(response: BDUIScreen.Load.Response) {
        let rootView = mapper.map(response.component) { [weak self] action in
            switch action {
            case .reload:
                self?.viewController?.triggerReload()
            }
        }
        viewController?.display(viewModel: .content(rootView: rootView))
    }

    func presentError(message: String) {
        viewController?.display(viewModel: .error(message: message))
    }
}
