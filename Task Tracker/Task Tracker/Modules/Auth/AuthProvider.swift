//
//  AuthProvider.swift
//  Task Tracker
//

import Foundation

final class AuthProvider: AuthProviderProtocol {
    private let authService: AuthServiceProtocol
    private let sessionDataStore: SessionDataStore

    init(authService: AuthServiceProtocol, sessionDataStore: SessionDataStore = .shared) {
        self.authService = authService
        self.sessionDataStore = sessionDataStore
    }

    func login(email: String, password: String) async throws -> UserSession {
        // TODO: реализация сетевого запроса и кэша
        return UserSession(token: "", userId: "", email: "")
    }

    func logout() {
        // Пустая реализация
    }
}
