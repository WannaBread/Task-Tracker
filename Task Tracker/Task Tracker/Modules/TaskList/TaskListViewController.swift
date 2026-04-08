import UIKit

final class TaskListViewController: UIViewController, TaskListDisplayLogic, TaskListViewDelegate {
    var interactor: TaskListBusinessLogic?
    var router: TaskListRoutingLogic?

    // Stores the current full (unfiltered) item list for id lookup during navigation.
    private var currentItems: [TaskListItemViewModel] = []

    // D2: Search controller
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search tasks"
        return sc
    }()

    private var taskListView: TaskListView {
        return view as! TaskListView
    }

    override func loadView() {
        view = TaskListView(delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(createTaskTapped)
        )
        interactor?.fetchTasks(request: TaskList.Fetch.Request())
    }

    // MARK: - TaskListDisplayLogic

    func display(viewModel: TaskList.Fetch.ViewModel) {
        if case .content(let items) = viewModel.state {
            currentItems = items
        }
        taskListView.update(with: viewModel.state)
    }

    func displayDelete(viewModel: TaskList.Delete.ViewModel) {
        if let error = viewModel.errorText {
            taskListView.update(with: .error(message: error))
        }
        // Обновлённый список придёт через display(viewModel:) от presentTasks в интеракторе
    }

    func displayToggle(viewModel: TaskList.ToggleCompletion.ViewModel) {
        if let error = viewModel.errorText {
            taskListView.update(with: .error(message: error))
        }
        // Обновлённый список придёт через display(viewModel:) от presentTasks в интеракторе
    }

    // MARK: - TaskListViewDelegate

    func taskListViewDidSelectTask(at index: Int) {
        guard index < currentItems.count else { return }
        router?.navigateToTaskDetail(taskId: currentItems[index].id)
    }

    func taskListViewDidDeleteTask(at index: Int) {
        interactor?.deleteTask(request: TaskList.Delete.Request(index: index))
    }

    func taskListViewDidToggleTask(at index: Int) {
        interactor?.toggleCompletion(request: TaskList.ToggleCompletion.Request(index: index))
    }

    func taskListViewDidTapCreateTask() {
        router?.navigateToCreateTask()
    }

    func taskListViewDidRequestRefresh() {
        interactor?.fetchTasks(request: TaskList.Fetch.Request())
    }

    // MARK: - Actions

    @objc private func createTaskTapped() {
        router?.navigateToCreateTask()
    }
}

// MARK: - UISearchResultsUpdating (D2)

extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text
        taskListView.tableManager.filter(by: query, in: taskListView.internalTableView)
    }
}
