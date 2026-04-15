import Foundation

// MARK: - TaskItemDTO


struct TaskItemDTO: Codable, Sendable {
    let id: String
    let title: String
    let taskDescription: String
    let priority: Int          // 0 = low, 1 = medium, 2 = high, 3 = critical
    let isCompleted: Bool
    let dueDate: String?       // "yyyy-MM-dd"
    let reminder: ReminderDTO?
    let recurrence: RecurrenceDTO?

    struct ReminderDTO: Codable, Sendable {
        let startDate: String  // "yyyy-MM-dd"
        let interval: Double   // секунды
        let isEnabled: Bool
    }

    struct RecurrenceDTO: Codable, Sendable {
        let type: String        // "weekly" | "monthly" | "yearly"
        let daysOfWeek: [Int]?  // для weekly: 1 = Пн … 7 = Вс
        let dayOfMonth: Int?    // для monthly
        let month: Int?         // для yearly
        let day: Int?           // для yearly
    }
}

