import Foundation

// MARK: - Session Manager Protocol

protocol SessionManagerProtocol {
    var currentSession: UserSession? { get }

    func save(session: UserSession)

    func loadSession() -> UserSession?

    func clearSession()

    var isAuthorized: Bool { get }
}
