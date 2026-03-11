//
//  AuthInteractor.swift
//  Task Tracker
//

import Foundation

final class AuthInteractor: AuthBusinessLogic {
    var presenter: AuthPresentationLogic?
    var provider: AuthProviderProtocol?
    var worker: AuthWorker?

    func didLoad(request: Auth.LifeCycle.Request) {
        // Пустая реализация вызова презентера
        presenter?.presentInitial(response: Auth.LifeCycle.Response())
    }

    func login(request: Auth.Login.Request) {
        // Вызов воркера и провайдера
    }
}
