import UIKit

// MARK: - TableManagerDelegate

protocol TaskListTableManagerDelegate: AnyObject {
    func didSelectTask(id: String)
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
}
