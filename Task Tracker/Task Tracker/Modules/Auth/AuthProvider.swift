import Foundation

final class AuthProvider: AuthProviderProtocol {
    private let authService: AuthServiceProtocol
    private let sessionDataStore: SessionDataStore

    init(authService: AuthServiceProtocol, sessionDataStore: SessionDataStore = .shared) {
        self.authService = authService
        self.sessionDataStore = sessionDataStore
    }

    func login(email: String, password: String) async throws -> UserSession {
        let request = LoginRequest(email: email, password: password)
        let response = try await authService.login(request: request)
        sessionDataStore.save(session: response.session)
        return response.session
    }

    func logout() {
        sessionDataStore.clear()
    }
}
