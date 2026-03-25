import UIKit

final class TaskListView: UIView {
    weak var delegate: TaskListViewDelegate?

    init(delegate: TaskListViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with state: TaskListViewState) {
    }
}
