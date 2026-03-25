import Foundation

// MARK: - TaskItemDTO

/// Codable DTO для элемента списка задач, получаемого с сервера.
/// Endpoint: GET https://alfaitmo.ru/server/echo/409172/todos
struct TaskItemDTO: Codable, Sendable {
    let id: String
    let title: String
    let taskDescription: String
    let priority: Int          // 0 = low, 1 = medium, 2 = high, 3 = critical
    let isCompleted: Bool
    let dueDate: String?       // "yyyy-MM-dd"
    let reminder: ReminderDTO?
    let recurrence: RecurrenceDTO?

    // MARK: - Nested DTOs

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

// MARK: - Mapping DTO → Domain

extension TaskItemDTO {
    func toTaskItem() -> TaskItem {
        let priority = TaskPriority(rawValue: priority) ?? .medium

        let parsedDueDate: Date? = dueDate.flatMap {
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            return fmt.date(from: $0)
        }

        let reminder: ReminderSettings? = self.reminder.flatMap {
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy-MM-dd"
            guard let start = fmt.date(from: $0.startDate) else { return nil }
            return ReminderSettings(
                startDate: start,
                interval: $0.interval,
                isEnabled: $0.isEnabled
            )
        }

        let recurrence: RecurrenceRule? = self.recurrence.flatMap {
            switch $0.type {
            case "weekly":
                return ($0.daysOfWeek).map { .weekly(daysOfWeek: $0) }
            case "monthly":
                return ($0.dayOfMonth).map { .monthly(dayOfMonth: $0) }
            case "yearly":
                guard let month = $0.month, let day = $0.day else { return nil }
                return .yearly(month: month, day: day)
            default:
                return nil
            }
        }

        return TaskItem(
            id: id,
            title: title,
            taskDescription: taskDescription,
            priority: priority,
            isCompleted: isCompleted,
            createdAt: Date(),
            dueDate: parsedDueDate,
            reminder: reminder,
            recurrence: recurrence
        )
    }
}
