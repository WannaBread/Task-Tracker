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
            viewController?.displayLoginSuccess()
            return
        case .failure(let error):
            switch error {
            case .validationFailed(let emailErr, let passwordErr):
                state = AuthViewState(
                    isLoading: false,
                    errorText: nil,
                    emailError: emailErr,
                    passwordError: passwordErr,
                    isLoginButtonEnabled: true
                )
            default:
                state = AuthViewState(
                    isLoading: false,
                    errorText: error.localizedMessage,
                    emailError: nil,
                    passwordError: nil,
                    isLoginButtonEnabled: true
                )
            }
        }
        viewController?.displayLogin(viewModel: Auth.Login.ViewModel(state: state))
    }

    func presentLoading() {
        let state = AuthViewState(
            isLoading: true,
            errorText: nil,
            emailError: nil,
            passwordError: nil,
            isLoginButtonEnabled: false
        )
        viewController?.displayLogin(viewModel: Auth.Login.ViewModel(state: state))
    }
}
