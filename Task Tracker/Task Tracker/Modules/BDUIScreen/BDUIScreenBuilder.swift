import UIKit

enum BDUIScreenBuilder {

    static func build(config: BDUIScreenConfig) -> UIViewController {
        let viewController = BDUIScreenViewController()
        let presenter = BDUIScreenPresenter()
        let worker = BDUIScreenWorker()
        let provider = BDUIScreenProvider(networkClient: URLSessionNetworkClient(), worker: worker)
        let interactor = BDUIScreenInteractor(config: config)
        let router = BDUIScreenRouter()

        viewController.interactor = interactor
        viewController.router = router

        interactor.presenter = presenter
        interactor.provider = provider

        presenter.viewController = viewController
        router.viewController = viewController

        viewController.title = config.title
        return viewController
    }
}
