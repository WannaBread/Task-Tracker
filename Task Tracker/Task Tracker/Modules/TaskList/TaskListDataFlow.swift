import Foundation

// MARK: - TaskList DataFlow

enum TaskList {

    // MARK: - Fetch Tasks

    enum Fetch {
        struct Request {}

        struct Response {
            let result: Result<[TaskItem], AppError>
        }

        struct ViewModel {
            let state: TaskListViewState
        }
    }

    // MARK: - Select Task

    enum SelectTask {
        struct Request {
            let index: Int
        }
    }

    // MARK: - Delete Task

    enum Delete {
        struct Request {
            let id: String
        }

        struct Response {
            let result: Result<Void, AppError>
        }

        struct ViewModel {
            let isSuccess: Bool
            let errorText: String?
        }
    }

    // MARK: - Toggle Completion

    enum ToggleCompletion {
        struct Request {
            let id: String
        }

        struct Response {
            let result: Result<TaskItem, AppError>
        }

        struct ViewModel {
            let isSuccess: Bool
            let errorText: String?
        }
    }

    // MARK: - Create Task

    enum CreateTask {
        struct Request {}
    }
    
    enum SearchTasks{
        struct Request{
            let query: String?
        }
    }
}

// MARK: - TaskList View State

enum TaskListViewState {
    case initial
    case loading
    case content(items: [TaskListItemViewModel])
    case empty(message: String)
    case error(message: String)
}

struct TaskListItemViewModel {
    let id: String
    let isCompleted: Bool
    let cellViewModel: TaskCellViewModel
}
