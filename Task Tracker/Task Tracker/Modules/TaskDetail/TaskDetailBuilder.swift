import UIKit

enum TaskDetailBuilder {
    static func build(taskId: String, taskService: TaskServiceProtocol) -> UIViewController {
        let viewController = TaskDetailViewController()
        let presenter = TaskDetailPresenter()
        let provider = TaskDetailProvider(taskService: taskService)
        let worker = TaskDetailWorker()
        let interactor = TaskDetailInteractor(taskId: taskId)
        let router = TaskDetailRouter()

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
