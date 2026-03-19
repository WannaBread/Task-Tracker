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
                emailError: nil,
                passwordError: nil,
                isLoginButtonEnabled: true,
                isSuccess: true
            )
        case .failure(let error):
            switch error {
            case .validationFailed(let emailErr, let passwordErr):
                state = AuthViewState(
                    isLoading: false,
                    errorText: nil,
                    emailError: emailErr,
                    passwordError: passwordErr,
                    isLoginButtonEnabled: true,
                    isSuccess: false
                )
            default:
                state = AuthViewState(
                    isLoading: false,
                    errorText: error.localizedMessage,
                    emailError: nil,
                    passwordError: nil,
                    isLoginButtonEnabled: true,
                    isSuccess: false
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
            isLoginButtonEnabled: false,
            isSuccess: false
        )
        viewController?.displayLogin(viewModel: Auth.Login.ViewModel(state: state))
    }
}
