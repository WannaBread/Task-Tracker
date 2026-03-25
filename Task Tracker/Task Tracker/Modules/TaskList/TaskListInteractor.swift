import Foundation

final class TaskListInteractor: TaskListBusinessLogic {
    var presenter: TaskListPresentationLogic?
    var provider: TaskListProviderProtocol?
    var worker: TaskListWorker?

    func fetchTasks(request: TaskList.Fetch.Request) {
    }

    func selectTask(request: TaskList.SelectTask.Request) {
    }

    func deleteTask(request: TaskList.Delete.Request) {
    }

    func toggleCompletion(request: TaskList.ToggleCompletion.Request) {
    }

    func didTapCreateTask(request: TaskList.CreateTask.Request) {
    }
}
