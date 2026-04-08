import Foundation

// MARK: - EchoAPIService
// Чистый HTTP-слой: только сетевые вызовы, никакой доменной логики и маппинга.

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

    func fetchTasks() async throws -> [TaskItemDTO] {
        do {
            return try await client.fetch([TaskItemDTO].self, from: todosURL)
        } catch let networkError as NetworkError {
            throw networkError.asAppError()
        }
    }

    func putTasks(_ dtos: [TaskItemDTO]) async throws {
        do {
            _ = try await client.send(dtos, to: todosURL, method: "PUT", responseType: [TaskItemDTO].self)
        } catch let networkError as NetworkError {
            throw networkError.asAppError()
        }
    }
}
