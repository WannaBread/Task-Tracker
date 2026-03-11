//
//  SessionManagerProtocol.swift
//  Task Tracker
//
//  YARCH Architecture — Session Manager Contract
//

import Foundation

// MARK: - Session Manager Protocol

/// Контракт менеджера сессий.
/// Отвечает за хранение, чтение и очистку данных сессии пользователя.
protocol SessionManagerProtocol {
    /// Текущая активная сессия (nil если пользователь не авторизован).
    var currentSession: UserSession? { get }

    /// Сохраняет сессию после успешной авторизации.
    func save(session: UserSession)

    /// Загружает сохранённую сессию.
    func loadSession() -> UserSession?

    /// Очищает данные сессии (logout).
    func clearSession()

    /// Проверяет, авторизован ли пользователь.
    var isAuthorized: Bool { get }
}
