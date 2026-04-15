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
        view.backgroundColor = .systemBackground
        title = "Task Detail"
        setupPlaceholder()
        interactor?.fetchTask(request: TaskDetail.Fetch.Request())
    }

    private func setupPlaceholder() {
        let label = UILabel()
        label.text = "Detail screen — coming soon"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
        ])
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
