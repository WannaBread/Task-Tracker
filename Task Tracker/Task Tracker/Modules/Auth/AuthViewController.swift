//
//  AuthViewController.swift
//  Task Tracker
//

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
        // Пустая реализация
    }

    func displayLogin(viewModel: Auth.Login.ViewModel) {
        // Пустая реализация
    }

    // MARK: - AuthViewDelegate
    func authViewDidTapLogin(email: String?, password: String?) {
        let req = Auth.Login.Request(email: email ?? "", password: password ?? "")
        interactor?.login(request: req)
    }
}
