import UIKit

final class TaskListView: UIView {
    weak var delegate: TaskListViewDelegate?

    // MARK: - Subviews

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = DS.Cell.estimatedRowHeight
        return tv
    }()

    private let stateView: DSStateView = {
        let v = DSStateView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        return v
    }()

    // D1: Pull-to-refresh
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        return rc
    }()

    // MARK: - Table manager

    let tableManager = TaskListTableManager()

    // MARK: - Init

    init(delegate: TaskListViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupUI()
        tableManager.delegate = self
        tableManager.configure(tableView: tableView)
        tableView.refreshControl = refreshControl
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupUI() {
        backgroundColor = DS.Colors.background

        addSubview(tableView)
        addSubview(stateView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stateView.topAnchor.constraint(equalTo: topAnchor),
            stateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - State

    func update(with state: TaskListViewState) {
        refreshControl.endRefreshing()

        switch state {
        case .initial, .loading:
            tableView.isHidden = true
            stateView.isHidden = false
            stateView.configure(with: .loading(message: "Загрузка..."))

        case .content(let items):
            stateView.isHidden = true
            tableView.isHidden = false
            tableManager.update(items: items, in: tableView)

        case .empty(let message):
            tableView.isHidden = true
            stateView.isHidden = false
            stateView.configure(with: .empty(
                message: message.isEmpty ? "Задач пока нет" : message,
                image: nil
            ))

        case .error(let message):
            tableView.isHidden = true
            stateView.isHidden = false
            stateView.configure(with: .error(message: message, retryTitle: "Повторить"))
            stateView.onRetry = { [weak self] in
                self?.delegate?.taskListViewDidRequestRefresh()
            }
        }
    }

    // MARK: - Actions

    @objc private func refreshPulled() {
        delegate?.taskListViewDidRequestRefresh()
    }
}

// MARK: - TaskListTableManagerDelegate

extension TaskListView: TaskListTableManagerDelegate {
    func didSelectTask(id: String) {
        guard let index = tableManager.indexInAllItems(forId: id) else { return }
        delegate?.taskListViewDidSelectTask(at: index)
    }

    func didToggleTask(id: String) {
        guard let index = tableManager.indexInAllItems(forId: id) else { return }
        delegate?.taskListViewDidToggleTask(at: index)
    }

    func didDeleteTask(id: String) {
        guard let index = tableManager.indexInAllItems(forId: id) else { return }
        delegate?.taskListViewDidDeleteTask(at: index)
    }
}
