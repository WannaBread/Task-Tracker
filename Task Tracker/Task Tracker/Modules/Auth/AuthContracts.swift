//
//  AuthContracts.swift
//  Task Tracker
//
//  YARCH Architecture — Auth Module Contracts
//

import UIKit

// MARK: - Auth Display Logic (Presenter → ViewController)

protocol AuthDisplayLogic: AnyObject {
    func displayInitial(viewModel: Auth.LifeCycle.ViewModel)
    func displayLogin(viewModel: Auth.Login.ViewModel)
}

// MARK: - Auth Business Logic (ViewController → Interactor)

protocol AuthBusinessLogic {
    func didLoad(request: Auth.LifeCycle.Request)
    func login(request: Auth.Login.Request)
}

// MARK: - Auth Presentation Logic (Interactor → Presenter)

protocol AuthPresentationLogic {
    func presentInitial(response: Auth.LifeCycle.Response)
    func presentLogin(response: Auth.Login.Response)
}

// MARK: - Auth Routing Logic (Router)

protocol AuthRoutingLogic {
    func navigateToTaskList()
}

// MARK: - Auth Provider Protocol

protocol AuthProviderProtocol {
    func login(email: String, password: String) async throws -> UserSession
    func logout()
}

// MARK: - Auth View Delegate

protocol AuthViewDelegate: AnyObject {
    func authViewDidTapLogin(email: String?, password: String?)
}
