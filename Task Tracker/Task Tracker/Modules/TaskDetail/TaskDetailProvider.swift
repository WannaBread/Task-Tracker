import Foundation

final class TaskDetailProvider: TaskDetailProviderProtocol {
    private let taskDataStore: TaskDataStore

    init(taskService: TaskServiceProtocol, taskDataStore: TaskDataStore = .shared) {
        self.taskDataStore = taskDataStore
    }

    func fetchTask(id: String) async throws -> TaskItem {
        guard let task = taskDataStore.task(by: id) else { throw AppError.notFound }
        return task
    }

    func toggleCompletion(id: String) async throws -> TaskItem {
        guard let index = taskDataStore.tasks.firstIndex(where: { $0.id == id }) else {
            throw AppError.notFound
        }
        taskDataStore.tasks[index].isCompleted.toggle()
        return taskDataStore.tasks[index]
    }

    func deleteTask(id: String) async throws {
        taskDataStore.remove(taskId: id)
    }

    func updateTask(request: UpdateTaskRequest) async throws -> TaskItem {
        guard let index = taskDataStore.tasks.firstIndex(where: { $0.id == request.id }) else {
            throw AppError.notFound
        }
        var task = taskDataStore.tasks[index]
        if let title = request.title        { task.title = title }
        if let desc  = request.description  { task.taskDescription = desc }
        if let p     = request.priority     { task.priority = p }
        if let d     = request.dueDate      { task.dueDate = d }
        if let r     = request.reminder     { task.reminder = r }
        if let rec   = request.recurrence   { task.recurrence = rec }
        if let done  = request.isCompleted  { task.isCompleted = done }
        taskDataStore.tasks[index] = task
        return task
    }
}
