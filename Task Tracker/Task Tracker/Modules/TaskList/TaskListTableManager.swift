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

    // MARK: - Setup

    func configure(tableView: UITableView) {
        tableView.register(TaskListCell.self, forCellReuseIdentifier: TaskListCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Update

    func update(items: [TaskListItemViewModel], in tableView: UITableView) {
        self.items = items
        tableView.reloadData()
    }

    // MARK: - Accessors

    func indexInAllItems(forId id: String) -> Int? {
        items.firstIndex(where: { $0.id == id })
    }
}

// MARK: - UITableViewDataSource

extension TaskListTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskListCell.reuseIdentifier,
            for: indexPath
        ) as! TaskListCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TaskListTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < items.count else { return }
        delegate?.didSelectTask(id: items[indexPath.row].id)
    }

    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard indexPath.row < items.count else { return nil }
        let item = items[indexPath.row]

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
        guard indexPath.row < items.count else { return nil }
        let item = items[indexPath.row]

        let action = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, done in
            self?.delegate?.didDeleteTask(id: item.id)
            done(true)
        }
        action.image = UIImage(systemName: "trash.fill")

        return UISwipeActionsConfiguration(actions: [action])
    }
}
