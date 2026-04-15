import Foundation

final class TaskListWorker {

    // MARK: - Sorting / Filtering

    func sortTasksByDate(_ tasks: [TaskItem]) -> [TaskItem] {
        return tasks.sorted {
            if $0.isCompleted != $1.isCompleted {
                return !$0.isCompleted
            }
            return $0.createdAt > $1.createdAt
        }
    }

    func filter(tasks: [TaskItem], priority: TaskPriority) -> [TaskItem] {
        return tasks.filter { $0.priority == priority }
    }

    func search(tasks: [TaskItem], query: String) -> [TaskItem] {
        guard !query.isEmpty else { return tasks }
        return tasks.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }

    // MARK: - Mapping: DTO → Domain

    func toDomain(_ dto: TaskItemDTO) -> TaskItem {
        let priority = TaskPriority(rawValue: dto.priority) ?? .medium

        let dueDate = dto.dueDate.flatMap { Self.parseYMD($0) }

        let reminder: ReminderSettings? = dto.reminder.flatMap {
            guard let start = Self.parseYMD($0.startDate) else { return nil }
            return ReminderSettings(startDate: start, interval: $0.interval, isEnabled: $0.isEnabled)
        }

        let recurrence: RecurrenceRule? = dto.recurrence.flatMap {
            switch $0.type {
            case "weekly":  return $0.daysOfWeek.map { .weekly(daysOfWeek: $0) }
            case "monthly": return $0.dayOfMonth.map { .monthly(dayOfMonth: $0) }
            case "yearly":
                guard let m = $0.month, let d = $0.day else { return nil }
                return .yearly(month: m, day: d)
            default: return nil
            }
        }

        return TaskItem(
            id: dto.id,
            title: dto.title,
            taskDescription: dto.taskDescription,
            priority: priority,
            isCompleted: dto.isCompleted,
            createdAt: Date(),
            dueDate: dueDate,
            reminder: reminder,
            recurrence: recurrence
        )
    }

    // MARK: - Mapping: Domain → DTO

    func toDTO(_ task: TaskItem) -> TaskItemDTO {
        TaskItemDTO(
            id: task.id,
            title: task.title,
            taskDescription: task.taskDescription,
            priority: task.priority.rawValue,
            isCompleted: task.isCompleted,
            dueDate: task.dueDate.map { Self.formatYMD($0) },
            reminder: task.reminder.map {
                TaskItemDTO.ReminderDTO(
                    startDate: Self.formatYMD($0.startDate),
                    interval: $0.interval,
                    isEnabled: $0.isEnabled
                )
            },
            recurrence: task.recurrence.map { rule in
                switch rule {
                case .weekly(let days):
                    return TaskItemDTO.RecurrenceDTO(type: "weekly", daysOfWeek: days, dayOfMonth: nil, month: nil, day: nil)
                case .monthly(let day):
                    return TaskItemDTO.RecurrenceDTO(type: "monthly", daysOfWeek: nil, dayOfMonth: day, month: nil, day: nil)
                case .yearly(let month, let day):
                    return TaskItemDTO.RecurrenceDTO(type: "yearly", daysOfWeek: nil, dayOfMonth: nil, month: month, day: day)
                }
            }
        )
    }

    // MARK: - Date helpers

    private static func parseYMD(_ string: String) -> Date? {
        let parts = string.split(separator: "-")
        guard parts.count == 3,
              let year  = Int(parts[0]),
              let month = Int(parts[1]),
              let day   = Int(parts[2]) else { return nil }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC") ?? .current
        var c = DateComponents()
        c.year = year; c.month = month; c.day = day
        return calendar.date(from: c)
    }

    private static func formatYMD(_ date: Date) -> String {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC") ?? .current
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", c.year ?? 0, c.month ?? 0, c.day ?? 0)
    }
}
