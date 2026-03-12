import Foundation

final class TaskListPresenter: TaskListPresentationLogic {
    weak var viewController: TaskListDisplayLogic?

    func presentTasks(response: TaskList.Fetch.Response) {
    }

    func presentDelete(response: TaskList.Delete.Response) {
    }

    func presentToggle(response: TaskList.ToggleCompletion.Response) {
    }
}
