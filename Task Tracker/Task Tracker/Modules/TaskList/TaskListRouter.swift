import UIKit

final class TaskListRouter: TaskListRoutingLogic {
    weak var viewController: UIViewController?
    private let taskService: TaskServiceProtocol

    init(taskService: TaskServiceProtocol) {
        self.taskService = taskService
    }

    func navigateToTaskDetail(taskId: String) {
        let config = BDUIScreenConfig(
            title: "🤨",
            source: .remote(endpoint: "https://alfaitmo.ru/server/echo/409172/bdui-task-detail")
        )
        let bduiVC = BDUIScreenBuilder.build(config: config)
        viewController?.navigationController?.pushViewController(bduiVC, animated: true)
    }

    func navigateToCreateTask() {
        let alert = UIAlertController(
            title: "Create Task",
            message: "Coming soon",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
}
