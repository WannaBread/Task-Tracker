import Foundation

final class BDUIScreenInteractor: BDUIScreenBusinessLogic {
    var presenter: BDUIScreenPresentationLogic?
    var provider: BDUIScreenProviderProtocol?

    private let config: BDUIScreenConfig

    init(config: BDUIScreenConfig) {
        self.config = config
    }

    // MARK: - BDUIScreenBusinessLogic

    func loadScreen(request: BDUIScreen.Load.Request) {
        presenter?.presentLoading()
        Task { [weak self] in
            guard let self else { return }
            do {
                guard let provider else { return }
                let component = try await provider.fetchComponent(source: config.source)
                await MainActor.run {
                    self.presenter?.presentScreen(response: BDUIScreen.Load.Response(component: component))
                }
            } catch {
                await MainActor.run {
                    self.presenter?.presentError(message: error.localizedDescription)
                }
            }
        }
    }
}
