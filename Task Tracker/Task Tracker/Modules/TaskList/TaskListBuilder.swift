import UIKit

enum TaskListBuilder {
    static func build(taskService: TaskServiceProtocol) -> UIViewController {
        let viewController = TaskListViewController()
        let presenter = TaskListPresenter()
        let worker = TaskListWorker()
        let provider = TaskListProvider(taskService: taskService, worker: worker)
        let interactor = TaskListInteractor()
        let router = TaskListRouter(taskService: taskService)

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
