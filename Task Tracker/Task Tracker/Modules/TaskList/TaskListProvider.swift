import Foundation

final class TaskListProvider: TaskListProviderProtocol {
    private let taskService: TaskServiceProtocol
    private let taskDataStore: TaskDataStore

    init(taskService: TaskServiceProtocol, taskDataStore: TaskDataStore = .shared) {
        self.taskService = taskService
        self.taskDataStore = taskDataStore
    }

    func fetchTasks() async throws -> [TaskItem] {
        let response = try await taskService.fetchTasks()
        taskDataStore.tasks = response.tasks
        return response.tasks
    }

    func deleteTask(id: String) async throws {
        try await taskService.deleteTask(by: id)
        taskDataStore.remove(taskId: id)
    }

    func toggleCompletion(id: String) async throws -> TaskItem {
        let updated = try await taskService.toggleCompletion(taskId: id)
        taskDataStore.update(task: updated)
        return updated
    }
}
