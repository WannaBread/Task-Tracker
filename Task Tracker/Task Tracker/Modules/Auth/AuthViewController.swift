import UIKit

final class AuthViewController: UIViewController, AuthDisplayLogic, AuthViewDelegate {
    var interactor: AuthBusinessLogic?
    var router: AuthRoutingLogic?

    private var authView: AuthView {
        return view as! AuthView
    }

    override func loadView() {
        view = AuthView(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.didLoad(request: Auth.LifeCycle.Request())
    }

    // MARK: - AuthDisplayLogic

    func displayInitial(viewModel: Auth.LifeCycle.ViewModel) {
        authView.update(with: viewModel.state)
    }

    func displayLogin(viewModel: Auth.Login.ViewModel) {
        authView.update(with: viewModel.state)
    }

    func displayLoginSuccess() {
        router?.navigateToTaskList()
    }

    func displayFieldValidation(viewModel: Auth.Validate.ViewModel) {
        switch viewModel.field {
        case .email:
            authView.updateEmailValidation(error: viewModel.error)
        case .password:
            authView.updatePasswordValidation(error: viewModel.error)
        }
    }

    // MARK: - AuthViewDelegate

    func authViewDidTapLogin(email: String?, password: String?) {
        let req = Auth.Login.Request(email: email ?? "", password: password ?? "")
        interactor?.login(request: req)
    }

    func authViewDidChangeEmail(_ email: String) {
        interactor?.validate(request: Auth.Validate.Request(field: .email, text: email))
    }

    func authViewDidChangePassword(_ password: String) {
        interactor?.validate(request: Auth.Validate.Request(field: .password, text: password))
    }
}
