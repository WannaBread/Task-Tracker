//
//  TaskListViewController.swift
//  Task Tracker
//

import UIKit

final class TaskListViewController: UIViewController, TaskListDisplayLogic, TaskListViewDelegate {
    var interactor: TaskListBusinessLogic?
    var router: TaskListRoutingLogic?

    private var taskListView: TaskListView {
        return view as! TaskListView
    }

    override func loadView() {
        view = TaskListView(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchTasks(request: TaskList.Fetch.Request())
    }

    // MARK: - TaskListDisplayLogic
    func display(viewModel: TaskList.Fetch.ViewModel) {}
    func displayDelete(viewModel: TaskList.Delete.ViewModel) {}
    func displayToggle(viewModel: TaskList.ToggleCompletion.ViewModel) {}

    // MARK: - TaskListViewDelegate
    func taskListViewDidSelectTask(at index: Int) {
        interactor?.selectTask(request: TaskList.SelectTask.Request(index: index))
    }
    func taskListViewDidDeleteTask(at index: Int) {
        interactor?.deleteTask(request: TaskList.Delete.Request(index: index))
    }
    func taskListViewDidToggleTask(at index: Int) {
        interactor?.toggleCompletion(request: TaskList.ToggleCompletion.Request(index: index))
    }
    func taskListViewDidTapCreateTask() {
        interactor?.didTapCreateTask(request: TaskList.CreateTask.Request())
    }
}
