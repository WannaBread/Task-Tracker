//
//  TaskListPresenter.swift
//  Task Tracker
//

import Foundation

final class TaskListPresenter: TaskListPresentationLogic {
    weak var viewController: TaskListDisplayLogic?

    func presentTasks(response: TaskList.Fetch.Response) {
        // TODO: реализация
    }

    func presentDelete(response: TaskList.Delete.Response) {
        // TODO: реализация
    }

    func presentToggle(response: TaskList.ToggleCompletion.Response) {
        // TODO: реализация
    }
}
