import Foundation

// MARK: - Task Data Store

final class TaskDataStore {

    static let shared = TaskDataStore()

    private init() {}

    var tasks: [TaskItem] = []

    func task(by id: String) -> TaskItem? {
        return tasks.first { $0.id == id }
    }

    func update(task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }

    func remove(taskId: String) {
        tasks.removeAll { $0.id == taskId }
    }

    func add(task: TaskItem) {
        tasks.append(task)
    }
}
