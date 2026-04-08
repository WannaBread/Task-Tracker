import Foundation

final class TaskDetailProvider: TaskDetailProviderProtocol {
    private let taskService: TaskServiceProtocol
    private let taskDataStore: TaskDataStore

    init(taskService: TaskServiceProtocol, taskDataStore: TaskDataStore = .shared) {
        self.taskService = taskService
        self.taskDataStore = taskDataStore
    }

    func fetchTask(id: String) async throws -> TaskItem {
        // Placeholder: look up in the shared data store if available
        if let task = taskDataStore.tasks.first(where: { $0.id == id }) {
            return task
        }
        throw AppError.unknown
    }

    func toggleCompletion(id: String) async throws -> TaskItem {
        guard var task = taskDataStore.tasks.first(where: { $0.id == id }) else {
            throw AppError.unknown
        }
        task = TaskItem(
            id: task.id,
            title: task.title,
            taskDescription: task.taskDescription,
            priority: task.priority,
            isCompleted: !task.isCompleted,
            createdAt: task.createdAt,
            dueDate: task.dueDate,
            reminder: task.reminder,
            recurrence: task.recurrence
        )
        return task
    }

    func deleteTask(id: String) async throws {
        // No-op placeholder
    }

    func updateTask(request: UpdateTaskRequest) async throws -> TaskItem {
        guard let task = taskDataStore.tasks.first(where: { $0.id == request.id }) else {
            throw AppError.unknown
        }
        return task
    }
}
