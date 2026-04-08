import Foundation

// MARK: - Mapping DTO → Domain

extension TaskItemDTO {
    func toTaskItem() -> TaskItem {
        let priority = TaskPriority(rawValue: priority) ?? .medium

        let parsedDueDate: Date? = dueDate.flatMap { Self.parseYMD($0) }

        let reminder: ReminderSettings? = self.reminder.flatMap {
            guard let start = Self.parseYMD($0.startDate) else { return nil }
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

    /// Parses a "yyyy-MM-dd" string using Calendar to avoid @MainActor-isolated DateFormatter.
    private static func parseYMD(_ string: String) -> Date? {
        let parts = string.split(separator: "-")
        guard parts.count == 3,
              let year = Int(parts[0]),
              let month = Int(parts[1]),
              let day = Int(parts[2]) else { return nil }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC") ?? .current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return calendar.date(from: components)
    }
}
