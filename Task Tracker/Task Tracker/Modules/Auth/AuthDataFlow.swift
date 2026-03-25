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

    // MARK: - Validate Use Case (real-time debounced)

    enum Validate {
        enum Field { case email, password }

        struct Request {
            let field: Field
            let text: String
        }

        struct Response {
            let field: Field
            let error: String?
        }

        struct ViewModel {
            let field: Field
            let error: String?
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

    static let initial = AuthViewState(
        isLoading: false,
        errorText: nil,
        emailError: nil,
        passwordError: nil,
        isLoginButtonEnabled: true
    )
}
