import Foundation

// MARK: - Session Data Store

final class SessionDataStore {

    static let shared = SessionDataStore()

    private init() {}

    var currentSession: UserSession?

    var isAuthorized: Bool {
        return currentSession != nil
    }

    func save(session: UserSession) {
        currentSession = session
    }

    func clear() {
        currentSession = nil
    }
}
