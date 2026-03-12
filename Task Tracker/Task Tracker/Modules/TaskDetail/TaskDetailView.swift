import UIKit

final class TaskDetailView: UIView {
    weak var delegate: TaskDetailViewDelegate?

    init(delegate: TaskDetailViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with state: TaskDetailViewState) {
    }
}
