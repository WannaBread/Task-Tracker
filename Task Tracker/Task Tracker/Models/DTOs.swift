//
//  DTOs.swift
//  Task Tracker
//
//  YARCH Architecture — Data Transfer Objects
//

import Foundation

// MARK: - Auth DTOs

struct LoginRequest: Equatable {
    let email: String
    let password: String
}

struct LoginResponse: Equatable {
    let session: UserSession
}

// MARK: - Task DTOs

struct TaskListResponse: Equatable {
    let tasks: [TaskItem]
}

struct TaskDetailResponse: Equatable {
    let task: TaskItem
}

/// Запрос на создание задачи.
struct CreateTaskRequest: Equatable {
    let title: String
    let description: String
    let priority: TaskPriority
    let dueDate: Date?
    let reminder: ReminderSettings?
    let recurrence: RecurrenceRule?
}

/// Запрос на обновление задачи.
struct UpdateTaskRequest: Equatable {
    let id: String
    let title: String?
    let description: String?
    let priority: TaskPriority?
    let dueDate: Date?
    let reminder: ReminderSettings?
    let recurrence: RecurrenceRule?
    let isCompleted: Bool?
}
