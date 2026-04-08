import UIKit

enum TaskListBuilder {
    static func build(taskService: TaskServiceProtocol) -> UIViewController {
        let viewController = TaskListViewController()
        let presenter = TaskListPresenter()
        let provider = TaskListProvider(taskService: taskService)
        let worker = TaskListWorker()
        let interactor = TaskListInteractor()
        let router = TaskListRouter()

        viewController.interactor = interactor
        viewController.router = router

        interactor.presenter = presenter
        interactor.provider = provider
        interactor.worker = worker

        presenter.viewController = viewController
        router.viewController = viewController
        router.taskService = taskService

        return viewController
    }
}
