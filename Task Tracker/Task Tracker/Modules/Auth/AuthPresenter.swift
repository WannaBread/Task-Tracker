import Foundation

final class AuthPresenter: AuthPresentationLogic {
    weak var viewController: AuthDisplayLogic?

    func presentInitial(response: Auth.LifeCycle.Response) {
        viewController?.displayInitial(viewModel: Auth.LifeCycle.ViewModel(state: .initial))
    }

    func presentLogin(response: Auth.Login.Response) {
    }
}
