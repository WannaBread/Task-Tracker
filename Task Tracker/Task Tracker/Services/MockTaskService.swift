import Foundation

final class MockTaskService: TaskServiceProtocol {
    func fetchTasks() async throws -> [TaskItemDTO] {
        return []
    }

    func putTasks(_ dtos: [TaskItemDTO]) async throws {}
}
