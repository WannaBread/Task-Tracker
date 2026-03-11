//
//  TaskDetailProvider.swift
//  Task Tracker
//

import Foundation

final class TaskDetailProvider: TaskDetailProviderProtocol {
    private let taskService: TaskServiceProtocol
    private let taskDataStore: TaskDataStore

    init(taskService: TaskServiceProtocol, taskDataStore: TaskDataStore = .shared) {
        self.taskService = taskService
        self.taskDataStore = taskDataStore
    }

    func fetchTask(id: String) async throws -> TaskItem {
        fatalError("Not implemented")
    }

    func toggleCompletion(id: String) async throws -> TaskItem {
        fatalError("Not implemented")
    }

    func deleteTask(id: String) async throws {
        // Пустая реализация
    }

    func updateTask(request: UpdateTaskRequest) async throws -> TaskItem {
        fatalError("Not implemented")
    }
}
