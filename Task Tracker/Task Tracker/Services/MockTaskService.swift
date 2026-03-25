import Foundation

final class MockTaskService: TaskServiceProtocol {
    func fetchTasks() async throws -> TaskListResponse {
        return TaskListResponse(tasks: [])
    }

    func fetchTask(by id: String) async throws -> TaskDetailResponse {
        throw AppError.notFound
    }

    func createTask(request: CreateTaskRequest) async throws -> TaskItem {
        throw AppError.unknown
    }

    func updateTask(request: UpdateTaskRequest) async throws -> TaskItem {
        throw AppError.unknown
    }

    func toggleCompletion(taskId: String) async throws -> TaskItem {
        throw AppError.unknown
    }

    func deleteTask(by id: String) async throws {}
}
