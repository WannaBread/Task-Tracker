import Foundation

// MARK: - TodoAPIService

final class EchoAPIService: TaskServiceProtocol {

    private let client: NetworkClientProtocol
    private let todosURL = URL(string: "https://alfaitmo.ru/server/echo/409172/todos")!

    init(client: NetworkClientProtocol? = nil) {
        if let client {
            self.client = client
        } else if NetworkConfig.useLocalFallback {
            self.client = BundleNetworkClient()
        } else {
            self.client = URLSessionNetworkClient()
        }
    }

    // MARK: - TaskServiceProtocol

    func fetchTasks() async throws -> TaskListResponse {
        do {
            let dtos = try await client.fetch([TaskItemDTO].self, from: todosURL)
            let items = dtos.map { $0.toTaskItem() }
            return TaskListResponse(tasks: items)
        } catch let networkError as NetworkError {
            throw networkError.asAppError()
        }
    }

    func fetchTask(by id: String) async throws -> TaskDetailResponse {
        // Echo API возвращает весь список — ищем нужный элемент локально
        guard let task = TaskDataStore.shared.task(by: id) else {
            throw AppError.notFound
        }
        return TaskDetailResponse(task: task)
    }

    func createTask(request: CreateTaskRequest) async throws -> TaskItem {
        throw AppError.serverError("Create is not supported by this API.")
    }

    func updateTask(request: UpdateTaskRequest) async throws -> TaskItem {
        throw AppError.serverError("Update is not supported by this API.")
    }

    func toggleCompletion(taskId: String) async throws -> TaskItem {
        // Echo API не персистит PATCH — выполняем оптимистичный локальный toggle
        guard let task = TaskDataStore.shared.task(by: taskId) else {
            throw AppError.notFound
        }
        var updated = task
        updated.isCompleted.toggle()
        return updated
    }

    func deleteTask(by id: String) async throws {
        // Echo API не поддерживает DELETE отдельных элементов — удаляем локально
        TaskDataStore.shared.remove(taskId: id)
    }
}
