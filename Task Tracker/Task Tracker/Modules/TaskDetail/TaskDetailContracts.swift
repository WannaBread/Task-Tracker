import UIKit

// MARK: - TaskDetail Display Logic (Presenter → ViewController)

protocol TaskDetailDisplayLogic: AnyObject {
    func display(viewModel: TaskDetail.Fetch.ViewModel)
    func displayToggle(viewModel: TaskDetail.ToggleCompletion.ViewModel)
    func displayDelete(viewModel: TaskDetail.Delete.ViewModel)
    func displayUpdate(viewModel: TaskDetail.Update.ViewModel)
}

// MARK: - TaskDetail Business Logic (ViewController → Interactor)

protocol TaskDetailBusinessLogic {
    func fetchTask(request: TaskDetail.Fetch.Request)
    func toggleCompletion(request: TaskDetail.ToggleCompletion.Request)
    func deleteTask(request: TaskDetail.Delete.Request)
    func updateTask(request: TaskDetail.Update.Request)
}

// MARK: - TaskDetail Presentation Logic (Interactor → Presenter)

protocol TaskDetailPresentationLogic {
    func presentTask(response: TaskDetail.Fetch.Response)
    func presentToggle(response: TaskDetail.ToggleCompletion.Response)
    func presentDelete(response: TaskDetail.Delete.Response)
    func presentUpdate(response: TaskDetail.Update.Response)
}

// MARK: - TaskDetail Routing Logic (Router)

protocol TaskDetailRoutingLogic {
    func navigateBack()
}

// MARK: - TaskDetail Provider Protocol

protocol TaskDetailProviderProtocol {
    func fetchTask(id: String) async throws -> TaskItem
    func toggleCompletion(id: String) async throws -> TaskItem
    func deleteTask(id: String) async throws
    func updateTask(request: UpdateTaskRequest) async throws -> TaskItem
}

// MARK: - TaskDetail View Delegate

protocol TaskDetailViewDelegate: AnyObject {
    func taskDetailViewDidToggleCompletion()
    func taskDetailViewDidDelete()
    func taskDetailViewDidUpdate(title: String, description: String, priority: TaskPriority)
}
