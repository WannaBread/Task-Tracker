import Foundation

final class AuthPresenter: AuthPresentationLogic {
    weak var viewController: AuthDisplayLogic?

    func presentInitial(response: Auth.LifeCycle.Response) {
        viewController?.displayInitial(viewModel: Auth.LifeCycle.ViewModel(state: .initial))
    }

    func presentLogin(response: Auth.Login.Response) {
        let state: AuthViewState
        switch response.result {
        case .success:
            state = AuthViewState(
                isLoading: false,
                errorText: nil,
                isLoginButtonEnabled: true,
                isSuccess: true
            )
        case .failure(let error):
            state = AuthViewState(
                isLoading: false,
                errorText: error.localizedMessage,
                isLoginButtonEnabled: true,
                isSuccess: false
            )
        }
        viewController?.displayLogin(viewModel: Auth.Login.ViewModel(state: state))
    }

    func presentLoading() {
        let state = AuthViewState(
            isLoading: true,
            errorText: nil,
            isLoginButtonEnabled: false,
            isSuccess: false
        )
        viewController?.displayLogin(viewModel: Auth.Login.ViewModel(state: state))
    }
}
