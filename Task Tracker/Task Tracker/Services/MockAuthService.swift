import Foundation

final class MockAuthService: AuthServiceProtocol {

    private let validEmail = "admin@app.app"
    private let validPassword = "12345678"

    func login(request: LoginRequest) async throws -> LoginResponse {
        try await Task.sleep(nanoseconds: 1_000_000_000)

        guard request.email == validEmail, request.password == validPassword else {
            throw AppError.invalidCredentials
        }

        let session = UserSession(
            token: UUID().uuidString,
            userId: UUID().uuidString,
            email: request.email
        )
        return LoginResponse(session: session)
    }

    func logout() async throws {}
}
