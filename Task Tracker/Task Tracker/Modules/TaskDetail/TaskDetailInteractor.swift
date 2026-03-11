//
//  TaskDetailInteractor.swift
//  Task Tracker
//

import Foundation

final class TaskDetailInteractor: TaskDetailBusinessLogic {
    var presenter: TaskDetailPresentationLogic?
    var provider: TaskDetailProviderProtocol?
    var worker: TaskDetailWorker?

    private let taskId: String

    init(taskId: String) {
        self.taskId = taskId
    }

    func fetchTask(request: TaskDetail.Fetch.Request) {
        // TODO: реализация
    }

    func toggleCompletion(request: TaskDetail.ToggleCompletion.Request) {
        // TODO: реализация
    }

    func deleteTask(request: TaskDetail.Delete.Request) {
        // TODO: реализация
    }

    func updateTask(request: TaskDetail.Update.Request) {
        // TODO: реализация
    }
}
