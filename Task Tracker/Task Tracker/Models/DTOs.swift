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

struct CreateTaskRequest: Equatable {
    let title: String
    let description: String
    let priority: TaskPriority
    let dueDate: Date?
    let reminder: ReminderSettings?
    let recurrence: RecurrenceRule?
}

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
