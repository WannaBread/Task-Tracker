import Foundation

final class TaskListPresenter: TaskListPresentationLogic {
    weak var viewController: TaskListDisplayLogic?

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()

    // MARK: - Loading

    func presentLoading() {
        viewController?.display(viewModel: TaskList.Fetch.ViewModel(state: .loading))
    }

    // MARK: - Fetch

    func presentTasks(response: TaskList.Fetch.Response) {
        let state: TaskListViewState

        switch response.result {
        case .success(let tasks):
            if tasks.isEmpty {
                state = .empty(message: "No tasks found.")
            } else {
                let items = tasks.map { makeViewModel(from: $0) }
                state = .content(items: items)
            }
        case .failure(let error):
            state = .error(message: error.localizedMessage)
        }

        viewController?.display(viewModel: TaskList.Fetch.ViewModel(state: state))
    }

    // MARK: - Delete

    func presentDelete(response: TaskList.Delete.Response) {
        switch response.result {
        case .success:
            viewController?.displayDelete(
                viewModel: TaskList.Delete.ViewModel(isSuccess: true, errorText: nil)
            )
        case .failure(let error):
            viewController?.displayDelete(
                viewModel: TaskList.Delete.ViewModel(isSuccess: false, errorText: error.localizedMessage)
            )
        }
    }

    // MARK: - Toggle

    func presentToggle(response: TaskList.ToggleCompletion.Response) {
        switch response.result {
        case .success:
            viewController?.displayToggle(
                viewModel: TaskList.ToggleCompletion.ViewModel(isSuccess: true, errorText: nil)
            )
        case .failure(let error):
            viewController?.displayToggle(
                viewModel: TaskList.ToggleCompletion.ViewModel(isSuccess: false, errorText: error.localizedMessage)
            )
        }
    }

    // MARK: - Private mapping

    private func makeViewModel(from task: TaskItem) -> TaskListItemViewModel {
        let dueDateText = task.dueDate.map { dateFormatter.string(from: $0) }

        return TaskListItemViewModel(
            id: task.id,
            title: task.title,
            priorityText: task.priority.title,
            dueDateText: dueDateText,
            isCompleted: task.isCompleted,
            hasReminder: task.reminder != nil,
            hasRecurrence: task.recurrence != nil
        )
    }
}
