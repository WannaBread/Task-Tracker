//
//  TaskDetailViewController.swift
//  Task Tracker
//

import UIKit

final class TaskDetailViewController: UIViewController, TaskDetailDisplayLogic, TaskDetailViewDelegate {
    var interactor: TaskDetailBusinessLogic?
    var router: TaskDetailRoutingLogic?

    private var taskDetailView: TaskDetailView {
        return view as! TaskDetailView
    }

    override func loadView() {
        view = TaskDetailView(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchTask(request: TaskDetail.Fetch.Request())
    }

    // MARK: - TaskDetailDisplayLogic
    func display(viewModel: TaskDetail.Fetch.ViewModel) {}
    func displayToggle(viewModel: TaskDetail.ToggleCompletion.ViewModel) {}
    func displayDelete(viewModel: TaskDetail.Delete.ViewModel) {}
    func displayUpdate(viewModel: TaskDetail.Update.ViewModel) {}

    // MARK: - TaskDetailViewDelegate
    func taskDetailViewDidToggleCompletion() {
        interactor?.toggleCompletion(request: TaskDetail.ToggleCompletion.Request())
    }

    func taskDetailViewDidDelete() {
        interactor?.deleteTask(request: TaskDetail.Delete.Request())
    }

    func taskDetailViewDidUpdate(title: String, description: String, priority: TaskPriority) {
        let req = TaskDetail.Update.Request(title: title, description: description, priority: priority)
        interactor?.updateTask(request: req)
    }
}
