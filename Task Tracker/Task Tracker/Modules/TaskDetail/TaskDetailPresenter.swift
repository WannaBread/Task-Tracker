import Foundation

final class TaskDetailPresenter: TaskDetailPresentationLogic {
    weak var viewController: TaskDetailDisplayLogic?

    func presentTask(response: TaskDetail.Fetch.Response) {
    }

    func presentToggle(response: TaskDetail.ToggleCompletion.Response) {
    }

    func presentDelete(response: TaskDetail.Delete.Response) {
    }

    func presentUpdate(response: TaskDetail.Update.Response) {
    }
}
