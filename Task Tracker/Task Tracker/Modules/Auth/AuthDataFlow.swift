import Foundation

// MARK: - Auth DataFlow

enum Auth {

    // MARK: - Life Cycle

    enum LifeCycle {
        struct Request {}

        struct Response {}

        struct ViewModel {
            let state: AuthViewState
        }
    }

    // MARK: - Login Use Case

    enum Login {
        struct Request {
            let email: String
            let password: String
        }

        struct Response {
            let result: Result<UserSession, AppError>
        }

        struct ViewModel {
            let state: AuthViewState
        }
    }
}

// MARK: - Auth View State

struct AuthViewState: Equatable {
    var isLoading: Bool
    var errorText: String?
    var emailError: String?
    var passwordError: String?
    var isLoginButtonEnabled: Bool
    var isSuccess: Bool

    static let initial = AuthViewState(
        isLoading: false,
        errorText: nil,
        emailError: nil,
        passwordError: nil,
        isLoginButtonEnabled: true,
        isSuccess: false
    )
}
