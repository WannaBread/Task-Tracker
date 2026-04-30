import Foundation

final class BDUIScreenProvider: BDUIScreenProviderProtocol {
    private let networkClient: NetworkClientProtocol
    private let worker: BDUIScreenWorker

    init(networkClient: NetworkClientProtocol, worker: BDUIScreenWorker) {
        self.networkClient = networkClient
        self.worker = worker
    }

    func fetchComponent(source: BDUIScreenConfig.Source) async throws -> BDUIComponent {
        switch source {
        case .remote(let endpoint):
            guard let url = worker.makeURL(from: endpoint) else {
                throw NetworkError.badURL
            }
            return try await networkClient.fetch(BDUIComponent.self, from: url)
        }
    }
}
