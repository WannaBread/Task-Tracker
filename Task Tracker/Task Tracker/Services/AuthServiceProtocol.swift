import Foundation

// MARK: - Auth Service Protocol

protocol AuthServiceProtocol {
    func login(request: LoginRequest) async throws -> LoginResponse

    func logout() async throws
}
