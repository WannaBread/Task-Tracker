//
//  TaskDetailDataFlow.swift
//  Task Tracker
//
//  YARCH Architecture — TaskDetail Module DataFlow
//

import Foundation

// MARK: - TaskDetail DataFlow

enum TaskDetail {

    enum Fetch {
        struct Request {}
        struct Response { let result: Result<TaskItem, AppError> }
        struct ViewModel { let state: TaskDetailViewState }
    }

    enum ToggleCompletion {
        struct Request {}
        struct Response { let result: Result<TaskItem, AppError> }
        struct ViewModel { let isSuccess: Bool; let errorText: String? }
    }

    enum Delete {
        struct Request {}
        struct Response { let result: Result<Void, AppError> }
        struct ViewModel { let isSuccess: Bool; let errorText: String? }
    }

    enum Update {
        struct Request {
            let title: String?
            let description: String?
            let priority: TaskPriority?
        }
        struct Response { let result: Result<TaskItem, AppError> }
        struct ViewModel { let state: TaskDetailViewState }
    }
}

// MARK: - View State

enum TaskDetailViewState: Equatable {
    case initial
    case loading
    case content(viewModel: TaskDetailContentViewModel)
    case error(message: String)
}

struct TaskDetailContentViewModel: Equatable {
    let title: String
    let description: String
    let priorityText: String
    let priorityValue: Int
    let isCompleted: Bool
    let hasReminder: Bool
    let hasRecurrence: Bool
}
