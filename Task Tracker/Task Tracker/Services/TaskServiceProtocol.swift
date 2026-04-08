import Foundation

// MARK: - Task Service Protocol
// Работает исключительно на уровне DTO — только HTTP, без доменной логики.

protocol TaskServiceProtocol {
    func fetchTasks() async throws -> [TaskItemDTO]
    func putTasks(_ dtos: [TaskItemDTO]) async throws
}
