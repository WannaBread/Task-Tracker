import UIKit

final class TaskListView: UIView {
    weak var delegate: TaskListViewDelegate?

    // MARK: - Subviews

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 64
        return tv
    }()

    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет задач"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Повторить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let errorStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        backgroundColor = .systemBackground

        errorStack.addArrangedSubview(errorLabel)
        errorStack.addArrangedSubview(retryButton)

        addSubview(tableView)
        addSubview(loadingView)
        addSubview(emptyLabel)
        addSubview(errorStack)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),

            errorStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            errorStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
        ])

        setOverlaysHidden(true)
    }

    // MARK: - State

    func update(with state: TaskListViewState) {
        refreshControl.endRefreshing()

        switch state {
        case .initial, .loading:
            tableView.isHidden = true
            emptyLabel.isHidden = true
            errorStack.isHidden = true
            loadingView.startAnimating()

        case .content(let items):
            loadingView.stopAnimating()
            emptyLabel.isHidden = true
            errorStack.isHidden = true
            tableView.isHidden = false
            tableManager.update(items: items, in: tableView)

        case .empty(let message):
            loadingView.stopAnimating()
            tableView.isHidden = true
            errorStack.isHidden = true
            emptyLabel.text = message.isEmpty ? "Нет задач" : message
            emptyLabel.isHidden = false

        case .error(let message):
            loadingView.stopAnimating()
            tableView.isHidden = true
            emptyLabel.isHidden = true
            errorLabel.text = message
            errorStack.isHidden = false
        }
    }

    // MARK: - Actions

    @objc private func retryTapped() {
        delegate?.taskListViewDidRequestRefresh()
    }

    @objc private func refreshPulled() {
        delegate?.taskListViewDidRequestRefresh()
    }

    // MARK: - Helpers

    private func setOverlaysHidden(_ hidden: Bool) {
        loadingView.isHidden = hidden
        emptyLabel.isHidden = hidden
        errorStack.isHidden = hidden
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
