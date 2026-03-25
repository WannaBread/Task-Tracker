import Foundation

final class TaskListWorker {

    /// Sorts tasks so incomplete tasks appear first, then by createdAt descending.
    func sortTasksByDate(_ tasks: [TaskItem]) -> [TaskItem] {
        return tasks.sorted {
            if $0.isCompleted != $1.isCompleted {
                return !$0.isCompleted
            }
            return $0.createdAt > $1.createdAt
        }
    }

    /// Returns only tasks matching the given priority level.
    func filter(tasks: [TaskItem], priority: TaskPriority) -> [TaskItem] {
        return tasks.filter { $0.priority == priority }
    }
}
