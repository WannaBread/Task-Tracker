import Foundation

final class AuthInteractor: AuthBusinessLogic {
    var presenter: AuthPresentationLogic?
    var provider: AuthProviderProtocol?
    var worker: AuthWorker?
    var router: AuthRoutingLogic?

    func didLoad(request: Auth.LifeCycle.Request) {
        presenter?.presentInitial(response: Auth.LifeCycle.Response())
    }

    func login(request: Auth.Login.Request) {
        guard let worker = worker else { return }

        let isEmailValid = worker.validate(email: request.email)
        let isPasswordValid = worker.validate(password: request.password)

        guard isEmailValid, isPasswordValid else {
            let emailErr = isEmailValid ? nil : "Enter a valid email"
            let passwordErr = isPasswordValid ? nil : "Password must be at least 6 characters"
            let response = Auth.Login.Response(
                result: .failure(.validationFailed(emailError: emailErr, passwordError: passwordErr))
            )
            presenter?.presentLogin(response: response)
            return
        }

        presenter?.presentLoading()

        Task { [weak self] in
            guard let self = self else { return }
            do {
                let session = try await self.provider?.login(
                    email: request.email,
                    password: request.password
                )
                let response = Auth.Login.Response(
                    result: .success(session ?? UserSession(token: "", userId: "", email: ""))
                )
                await MainActor.run {
                    self.presenter?.presentLogin(response: response)
                }
            } catch let error as AppError {
                let response = Auth.Login.Response(result: .failure(error))
                await MainActor.run {
                    self.presenter?.presentLogin(response: response)
                }
            } catch {
                let response = Auth.Login.Response(result: .failure(.unknown))
                await MainActor.run {
                    self.presenter?.presentLogin(response: response)
                }
            }
        }
    }
}
