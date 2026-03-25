import Foundation

// MARK: - Task Service Protocol

protocol TaskServiceProtocol {
    func fetchTasks() async throws -> TaskListResponse

    func fetchTask(by id: String) async throws -> TaskDetailResponse

    func createTask(request: CreateTaskRequest) async throws -> TaskItem

    func updateTask(request: UpdateTaskRequest) async throws -> TaskItem

    func toggleCompletion(taskId: String) async throws -> TaskItem

    func deleteTask(by id: String) async throws
}
