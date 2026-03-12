import Foundation

final class TaskDetailInteractor: TaskDetailBusinessLogic {
    var presenter: TaskDetailPresentationLogic?
    var provider: TaskDetailProviderProtocol?
    var worker: TaskDetailWorker?

    private let taskId: String

    init(taskId: String) {
        self.taskId = taskId
    }

    func fetchTask(request: TaskDetail.Fetch.Request) {
    }

    func toggleCompletion(request: TaskDetail.ToggleCompletion.Request) {
    }

    func deleteTask(request: TaskDetail.Delete.Request) {
    }

    func updateTask(request: TaskDetail.Update.Request) {
    }
}
