//
//  DomainModels.swift
//  Task Tracker
//
//  YARCH Architecture — Domain Models
//

import Foundation

// MARK: - User Session

/// Сессия авторизованного пользователя.
struct UserSession: Equatable, Codable {
    let token: String
    let userId: String
    let email: String
}

// MARK: - Task Priority (Важность)

/// Уровень важности задачи.
enum TaskPriority: Int, Equatable, Codable, CaseIterable, Comparable {
    case low = 0
    case medium = 1
    case high = 2
    case critical = 3

    var title: String {
        switch self {
        case .low:      return "Низкий"
        case .medium:   return "Средний"
        case .high:     return "Высокий"
        case .critical: return "Критический"
        }
    }

    static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Recurrence Rule (Повторение)

/// Правило повторения задачи.
enum RecurrenceRule: Equatable, Codable {
    /// Повторение каждый год в определённую дату.
    case yearly(month: Int, day: Int)

    /// Повторение каждый месяц в определённый день.
    case monthly(dayOfMonth: Int)

    /// Повторение по дням недели (1 = Пн, ..., 7 = Вс).
    case weekly(daysOfWeek: [Int])
}

// MARK: - Reminder Settings (Настройки напоминаний)

/// Настройки напоминания для задачи.
struct ReminderSettings: Equatable, Codable {
    /// Дата начала отправки напоминаний.
    let startDate: Date

    /// Интервал между напоминаниями (в секундах).
    let interval: TimeInterval

    /// Активны ли напоминания.
    var isEnabled: Bool
}

// MARK: - Task Item (Доменная сущность задачи)

/// Основная доменная модель задачи.
struct TaskItem: Equatable, Identifiable, Codable {
    let id: String
    var title: String
    var taskDescription: String
    var priority: TaskPriority
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?

    /// Настройки напоминания (опционально).
    var reminder: ReminderSettings?

    /// Правило повторения (опционально).
    var recurrence: RecurrenceRule?
}
