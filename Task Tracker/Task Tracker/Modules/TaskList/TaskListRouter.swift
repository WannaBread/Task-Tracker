import UIKit

final class TaskListRouter: TaskListRoutingLogic {
    weak var viewController: UIViewController?
    var taskService: TaskServiceProtocol?

    func navigateToTaskDetail(taskId: String) {
        guard let taskService else { return }
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
