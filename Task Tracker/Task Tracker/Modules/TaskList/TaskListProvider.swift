//
//  TaskListProvider.swift
//  Task Tracker
//

import Foundation

final class TaskListProvider: TaskListProviderProtocol {
    private let taskService: TaskServiceProtocol
    private let taskDataStore: TaskDataStore

    init(taskService: TaskServiceProtocol, taskDataStore: TaskDataStore = .shared) {
        self.taskService = taskService
        self.taskDataStore = taskDataStore
    }

    func fetchTasks() async throws -> [TaskItem] {
        return []
    }

    func deleteTask(id: String) async throws {
        // Пустая реализация
    }

    func toggleCompletion(id: String) async throws -> TaskItem {
        // Ожидается реализация
        fatalError("Not implemented")
    }
}
