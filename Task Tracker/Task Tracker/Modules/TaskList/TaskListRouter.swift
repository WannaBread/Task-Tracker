import UIKit

final class TaskListRouter: TaskListRoutingLogic {
    weak var viewController: UIViewController?
    private let taskService: TaskServiceProtocol

    init(taskService: TaskServiceProtocol) {
        self.taskService = taskService
    }

    func navigateToTaskDetail(taskId: String) {
        let detailVC = TaskDetailBuilder.build(taskId: taskId, taskService: taskService)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
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
