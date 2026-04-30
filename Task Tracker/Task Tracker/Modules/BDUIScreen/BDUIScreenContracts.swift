import UIKit

// MARK: - Display Logic (Presenter → ViewController)

protocol BDUIScreenDisplayLogic: AnyObject {
    func display(viewModel: BDUIScreen.Load.ViewModel)
    func triggerReload()
}

// MARK: - Business Logic (ViewController → Interactor)

protocol BDUIScreenBusinessLogic {
    func loadScreen(request: BDUIScreen.Load.Request)
}

// MARK: - Presentation Logic (Interactor → Presenter)

protocol BDUIScreenPresentationLogic {
    func presentLoading()
    func presentScreen(response: BDUIScreen.Load.Response)
    func presentError(message: String)
}

// MARK: - Routing Logic

protocol BDUIScreenRoutingLogic {
    func dismiss()
}

// MARK: - Provider Protocol

protocol BDUIScreenProviderProtocol {
    func fetchComponent(source: BDUIScreenConfig.Source) async throws -> BDUIComponent
}

// MARK: - View Delegate

protocol BDUIScreenViewDelegate: AnyObject {
    func bduiScreenViewDidTapRetry()
}
