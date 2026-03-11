//
//  SessionDataStore.swift
//  Task Tracker
//
//  YARCH Architecture — Shared Session Data Store
//

import Foundation

// MARK: - Session Data Store

/// Общее хранилище данных сессии.
/// Модули обращаются сюда для проверки авторизации.
final class SessionDataStore {

    static let shared = SessionDataStore()

    private init() {}

    /// Текущая сессия пользователя.
    var currentSession: UserSession?

    /// Авторизован ли пользователь.
    var isAuthorized: Bool {
        return currentSession != nil
    }

    /// Сохранить сессию.
    func save(session: UserSession) {
        currentSession = session
    }

    /// Очистить сессию (logout).
    func clear() {
        currentSession = nil
    }
}
