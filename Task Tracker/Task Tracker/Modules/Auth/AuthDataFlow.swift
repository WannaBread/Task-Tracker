//
//  AuthDataFlow.swift
//  Task Tracker
//
//  YARCH Architecture — Auth Module DataFlow (DTO)
//

import Foundation

// MARK: - Auth DataFlow

/// DataFlow описывает объекты для передачи данных (DTO) внутри Use Case.
/// Request — от ViewController к Interactor.
/// Response — от Interactor к Presenter.
/// ViewModel — от Presenter к ViewController.
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

/// Состояние UI экрана авторизации.
/// initial → loading → content / error
struct AuthViewState: Equatable {
    var isLoading: Bool
    var errorText: String?
    var isLoginButtonEnabled: Bool

    static let initial = AuthViewState(
        isLoading: false,
        errorText: nil,
        isLoginButtonEnabled: true
    )
}
