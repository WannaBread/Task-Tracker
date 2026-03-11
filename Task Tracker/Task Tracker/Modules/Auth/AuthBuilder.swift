//
//  AuthBuilder.swift
//  Task Tracker
//

import UIKit

enum AuthBuilder {
    static func build(authService: AuthServiceProtocol) -> UIViewController {
        let viewController = AuthViewController()
        let presenter = AuthPresenter()
        let provider = AuthProvider(authService: authService)
        let worker = AuthWorker()
        let interactor = AuthInteractor()
        let router = AuthRouter()

        viewController.interactor = interactor
        viewController.router = router

        interactor.presenter = presenter
        interactor.provider = provider
        interactor.worker = worker

        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
