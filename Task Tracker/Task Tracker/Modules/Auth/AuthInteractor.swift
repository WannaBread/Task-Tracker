import Foundation

final class AuthInteractor: AuthBusinessLogic {
    var presenter: AuthPresentationLogic?
    var provider: AuthProviderProtocol?
    var worker: AuthWorker?

    func didLoad(request: Auth.LifeCycle.Request) {
        presenter?.presentInitial(response: Auth.LifeCycle.Response())
    }

    func login(request: Auth.Login.Request) {
    }
}
