import UIKit

// MARK: - TaskList Display Logic (Presenter → ViewController)

protocol TaskListDisplayLogic: AnyObject {
    func display(viewModel: TaskList.Fetch.ViewModel)
    func displayDelete(viewModel: TaskList.Delete.ViewModel)
    func displayToggle(viewModel: TaskList.ToggleCompletion.ViewModel)
}

// MARK: - TaskList Business Logic (ViewController → Interactor)

protocol TaskListBusinessLogic {
    func fetchTasks(request: TaskList.Fetch.Request)
    func deleteTask(request: TaskList.Delete.Request)
    func toggleCompletion(request: TaskList.ToggleCompletion.Request)
}

// MARK: - TaskList Presentation Logic (Interactor → Presenter)

protocol TaskListPresentationLogic {
    func presentLoading()
    func presentTasks(response: TaskList.Fetch.Response)
    func presentDelete(response: TaskList.Delete.Response)
    func presentToggle(response: TaskList.ToggleCompletion.Response)
}

// MARK: - TaskList Routing Logic (Router)

protocol TaskListRoutingLogic {
    func navigateToTaskDetail(taskId: String)
    func navigateToCreateTask()
}

// MARK: - TaskList Provider Protocol

protocol TaskListProviderProtocol {
    var cachedTasks: [TaskItem] { get }
    func fetchTasks() async throws -> [TaskItem]
    func deleteTask(id: String) async throws
    func toggleCompletion(id: String) async throws -> TaskItem
}

// MARK: - TaskList View Delegate

protocol TaskListViewDelegate: AnyObject {
    func taskListViewDidSelectTask(at index: Int)
    func taskListViewDidDeleteTask(at index: Int)
    func taskListViewDidToggleTask(at index: Int)
    func taskListViewDidTapCreateTask()
    func taskListViewDidRequestRefresh()
}
