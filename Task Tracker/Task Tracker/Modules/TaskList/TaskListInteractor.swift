//
//  TaskListInteractor.swift
//  Task Tracker
//

import Foundation

final class TaskListInteractor: TaskListBusinessLogic {
    var presenter: TaskListPresentationLogic?
    var provider: TaskListProviderProtocol?
    var worker: TaskListWorker?

    func fetchTasks(request: TaskList.Fetch.Request) {
        // TODO: реализация
    }

    func selectTask(request: TaskList.SelectTask.Request) {
        // TODO: реализация
    }

    func deleteTask(request: TaskList.Delete.Request) {
        // TODO: реализация
    }

    func toggleCompletion(request: TaskList.ToggleCompletion.Request) {
        // TODO: реализация
    }

    func didTapCreateTask(request: TaskList.CreateTask.Request) {
        // TODO: реализация
    }
}
