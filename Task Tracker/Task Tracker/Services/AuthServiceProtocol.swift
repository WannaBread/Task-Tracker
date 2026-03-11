//
//  AuthServiceProtocol.swift
//  Task Tracker
//
//  YARCH Architecture — Auth Service Contract (Domain ↔ Data)
//

import Foundation

// MARK: - Auth Service Protocol

/// Контракт сервиса авторизации.
/// Отвечает за взаимодействие с бэкендом / локальным хранилищем для аутентификации.
/// Не содержит UIKit-зависимостей — чистый доменный/data-слой.
protocol AuthServiceProtocol {
    /// Выполняет вход по email и паролю.
    /// - Parameter request: Данные для входа (email, password).
    /// - Returns: Ответ с сессией пользователя.
    /// - Throws: `AppError` при ошибках.
    func login(request: LoginRequest) async throws -> LoginResponse

    /// Выполняет выход из аккаунта.
    func logout() async throws
}
