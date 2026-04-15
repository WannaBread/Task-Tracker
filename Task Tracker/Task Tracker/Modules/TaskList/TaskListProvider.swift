import Foundation

final class TaskListProvider: TaskListProviderProtocol {
    private let taskService: TaskServiceProtocol
    private let taskDataStore: TaskDataStore
    private let worker: TaskListWorker

    init(taskService: TaskServiceProtocol,
         worker: TaskListWorker,
         taskDataStore: TaskDataStore = .shared) {
        self.taskService = taskService
        self.worker = worker
        self.taskDataStore = taskDataStore
    }

    var cachedTasks: [TaskItem] { taskDataStore.tasks }

    // MARK: - TaskListProviderProtocol

    func fetchTasks() async throws -> [TaskItem] {
        let dtos = try await taskService.fetchTasks()
        let items = dtos.map { worker.toDomain($0) }
        taskDataStore.tasks = items
        return items
    }

    func deleteTask(id: String) async throws {
        taskDataStore.remove(taskId: id)
        try await persistCurrentTasks()
    }

    func toggleCompletion(id: String) async throws -> TaskItem {
        guard var task = taskDataStore.task(by: id) else {
            throw AppError.notFound
        }
        task.isCompleted.toggle()
        taskDataStore.update(task: task)
        try await persistCurrentTasks()
        return task
    }

    // MARK: - Private

    private func persistCurrentTasks() async throws {
        let dtos = taskDataStore.tasks.map { worker.toDTO($0) }
        try await taskService.putTasks(dtos)
    }
}
