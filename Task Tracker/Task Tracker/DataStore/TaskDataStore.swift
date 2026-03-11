//
//  TaskDataStore.swift
//  Task Tracker
//
//  YARCH Architecture — Shared Task Data Store
//

import Foundation

// MARK: - Task Data Store

/// Общее хранилище задач, доступное разным модулям.
/// Модули передают друг другу id задачи и обращаются к DataStore для получения данных.
final class TaskDataStore {

    static let shared = TaskDataStore()

    private init() {}

    /// Кэш загруженных задач.
    var tasks: [TaskItem] = []

    /// Получить задачу по id.
    func task(by id: String) -> TaskItem? {
        return tasks.first { $0.id == id }
    }

    /// Обновить задачу в кэше.
    func update(task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }

    /// Удалить задачу из кэша.
    func remove(taskId: String) {
        tasks.removeAll { $0.id == taskId }
    }

    /// Добавить задачу в кэш.
    func add(task: TaskItem) {
        tasks.append(task)
    }
}
