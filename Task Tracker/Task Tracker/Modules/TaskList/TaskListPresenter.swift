import UIKit

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
        let dueDateText = task.dueDate.map { dateFormatter.string(from: $0) } ?? ""

        var icons: [TaskCellViewModel.IconConfig] = []

        let completionSymbol = task.isCompleted ? "checkmark.circle.fill" : "circle"
        let completionColor = task.isCompleted ? DS.Colors.success : DS.Colors.iconDefault
        if let image = UIImage(systemName: completionSymbol) {
            icons.append(.init(image: image, tintColor: completionColor))
        }

        if task.reminder != nil, let image = UIImage(systemName: "bell.fill") {
            icons.append(.init(image: image, tintColor: DS.Colors.primary))
        }

        if task.recurrence != nil, let image = UIImage(systemName: "repeat") {
            icons.append(.init(image: image, tintColor: DS.Colors.success))
        }

        let cellVM = TaskCellViewModel(
            title: task.title,
            titleColor: Self.titleColor(for: task.priority.title),
            subtitle: dueDateText,
            icons: icons
        )

        return TaskListItemViewModel(
            id: task.id,
            isCompleted: task.isCompleted,
            cellViewModel: cellVM
        )
    }

    private static func titleColor(for priorityTitle: String) -> UIColor {
        switch priorityTitle {
        case "Low":      return DS.Colors.textSecondary
        case "Medium":   return DS.Colors.textPrimary
        case "High":     return DS.Colors.warning
        case "Critical": return DS.Colors.error
        default:         return DS.Colors.textPrimary
        }
    }
}
