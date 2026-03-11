//
//  TaskServiceProtocol.swift
//  Task Tracker
//
//  YARCH Architecture — Task Service Contract (Domain ↔ Data)
//

import Foundation

// MARK: - Task Service Protocol

/// Контракт сервиса задач.
/// Инкапсулирует операции CRUD над задачами.
/// Не содержит UIKit-зависимостей.
protocol TaskServiceProtocol {
    /// Загружает список всех задач пользователя.
    func fetchTasks() async throws -> TaskListResponse

    /// Загружает детальную информацию о задаче.
    func fetchTask(by id: String) async throws -> TaskDetailResponse

    /// Создаёт новую задачу.
    func createTask(request: CreateTaskRequest) async throws -> TaskItem

    /// Обновляет существующую задачу.
    func updateTask(request: UpdateTaskRequest) async throws -> TaskItem

    /// Переключает статус выполнения задачи.
    func toggleCompletion(taskId: String) async throws -> TaskItem

    /// Удаляет задачу.
    func deleteTask(by id: String) async throws
}
