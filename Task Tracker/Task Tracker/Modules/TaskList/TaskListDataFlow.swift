//
//  TaskListDataFlow.swift
//  Task Tracker
//
//  YARCH Architecture — TaskList Module DataFlow
//

import Foundation

// MARK: - TaskList DataFlow

enum TaskList {

    // MARK: - Fetch Tasks

    enum Fetch {
        struct Request {}

        struct Response {
            let result: Result<[TaskItem], AppError>
        }

        struct ViewModel {
            let state: TaskListViewState
        }
    }

    // MARK: - Select Task

    enum SelectTask {
        struct Request {
            let index: Int
        }
    }

    // MARK: - Delete Task

    enum Delete {
        struct Request {
            let index: Int
        }

        struct Response {
            let result: Result<Void, AppError>
        }

        struct ViewModel {
            let isSuccess: Bool
            let errorText: String?
        }
    }

    // MARK: - Toggle Completion

    enum ToggleCompletion {
        struct Request {
            let index: Int
        }

        struct Response {
            let result: Result<TaskItem, AppError>
        }

        struct ViewModel {
            let isSuccess: Bool
            let errorText: String?
        }
    }

    // MARK: - Create Task

    enum CreateTask {
        struct Request {}
    }
}

// MARK: - TaskList View State

enum TaskListViewState: Equatable {
    case initial
    case loading
    case content(items: [TaskListItemViewModel])
    case empty(message: String)
    case error(message: String)
}

struct TaskListItemViewModel: Equatable {
    let id: String
    let title: String
    let priorityText: String
    let dueDateText: String?
    let isCompleted: Bool
    let hasReminder: Bool
    let hasRecurrence: Bool
}
