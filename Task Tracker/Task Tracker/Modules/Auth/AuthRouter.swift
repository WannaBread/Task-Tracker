import UIKit

final class AuthRouter: AuthRoutingLogic {
    weak var viewController: UIViewController?

    func navigateToTaskList() {
        guard let scene = viewController?.view.window?.windowScene,
              let window = scene.windows.first else { return }

        let taskListVC = TaskListBuilder.build(taskService: EchoAPIService())
        let nav = UINavigationController(rootViewController: taskListVC)
        taskListVC.title = "Tasks"

        window.rootViewController = nav
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
