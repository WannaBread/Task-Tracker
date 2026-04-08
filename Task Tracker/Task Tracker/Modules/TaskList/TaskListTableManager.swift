import UIKit

// MARK: - TableManagerDelegate

protocol TaskListTableManagerDelegate: AnyObject {
    func didSelectTask(id: String)
    func didToggleTask(id: String)
    func didDeleteTask(id: String)
}

// MARK: - TaskListTableManager

final class TaskListTableManager: NSObject {
    weak var delegate: TaskListTableManagerDelegate?

    private var items: [TaskListItemViewModel] = []
    private var filteredItems: [TaskListItemViewModel] = []
    private var searchQuery: String = ""

    // MARK: - Setup

    func configure(tableView: UITableView) {
        tableView.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Update

    func update(items: [TaskListItemViewModel], in tableView: UITableView) {
        self.items = items
        applyFilter(in: tableView)
    }

    // MARK: - Search (D2)

    func filter(by query: String, in tableView: UITableView? = nil) {
        searchQuery = query
        if let tableView {
            applyFilter(in: tableView)
        }
    }

    // MARK: - Accessors

    /// Returns the index of an item (by id) in the full unfiltered items array.
    func indexInAllItems(forId id: String) -> Int? {
        items.firstIndex(where: { $0.id == id })
    }

    // MARK: - Private

    private func applyFilter(in tableView: UITableView) {
        if searchQuery.isEmpty {
            filteredItems = items
        } else {
            filteredItems = items.filter {
                $0.title.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension TaskListTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskListCell.reuseIdentifier,
            for: indexPath
        ) as! TaskListCell
        cell.configure(with: filteredItems[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TaskListTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < filteredItems.count else { return }
        delegate?.didSelectTask(id: filteredItems[indexPath.row].id)
    }

    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard indexPath.row < filteredItems.count else { return nil }
        let item = filteredItems[indexPath.row]

        let isCompleted = item.isCompleted
        let title = isCompleted ? "Отменить" : "Готово"
        let symbolName = isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle.fill"
        let color: UIColor = isCompleted ? .systemGray : .systemGreen

        let action = UIContextualAction(style: .normal, title: title) { [weak self] _, _, done in
            self?.delegate?.didToggleTask(id: item.id)
            done(true)
        }
        action.image = UIImage(systemName: symbolName)
        action.backgroundColor = color

        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard indexPath.row < filteredItems.count else { return nil }
        let item = filteredItems[indexPath.row]

        let action = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, done in
            self?.delegate?.didDeleteTask(id: item.id)
            done(true)
        }
        action.image = UIImage(systemName: "trash.fill")

        return UISwipeActionsConfiguration(actions: [action])
    }
}
