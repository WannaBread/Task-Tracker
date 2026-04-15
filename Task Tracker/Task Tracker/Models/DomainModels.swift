import Foundation

// MARK: - User Session

struct UserSession: Equatable, Codable {
    let token: String
    let userId: String
    let email: String
}

// MARK: - Task Priority

enum TaskPriority: Int, Equatable, Codable, CaseIterable, Comparable {
    case low = 0
    case medium = 1
    case high = 2
    case critical = 3

    var title: String {
        switch self {
        case .low:      return "Low"
        case .medium:   return "Medium"
        case .high:     return "High"
        case .critical: return "Critical"
        }
    }

    static func < (lhs: TaskPriority, rhs: TaskPriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Recurrence Rule

enum RecurrenceRule: Equatable, Codable {
    case yearly(month: Int, day: Int)

    case monthly(dayOfMonth: Int)

    case weekly(daysOfWeek: [Int])
}

// MARK: - Reminder Settings

struct ReminderSettings: Equatable, Codable {
    let startDate: Date

    let interval: TimeInterval

    var isEnabled: Bool
}

// MARK: - Task Item

struct TaskItem: Equatable{
    let id: String
    var title: String
    var taskDescription: String
    var priority: TaskPriority
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?

    var reminder: ReminderSettings?

    var recurrence: RecurrenceRule?
}
