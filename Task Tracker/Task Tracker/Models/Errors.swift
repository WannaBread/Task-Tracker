//
//  Errors.swift
//  Task Tracker
//
//  YARCH Architecture — Application Errors
//

import Foundation

// MARK: - App Error

enum AppError: Error, Equatable {
    case networkError(String)
    case authFailed(String)
    case invalidCredentials
    case sessionExpired
    case notFound
    case serverError(String)
    case unknown

    var localizedMessage: String {
        switch self {
        case .networkError(let msg):
            return "Ошибка сети: \(msg)"
        case .authFailed(let msg):
            return "Ошибка авторизации: \(msg)"
        case .invalidCredentials:
            return "Неверный email или пароль"
        case .sessionExpired:
            return "Сессия истекла. Войдите снова"
        case .notFound:
            return "Данные не найдены"
        case .serverError(let msg):
            return "Ошибка сервера: \(msg)"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
}
