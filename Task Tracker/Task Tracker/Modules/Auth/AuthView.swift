import UIKit

final class AuthView: UIView {
    weak var delegate: AuthViewDelegate?

    init(delegate: AuthViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with state: AuthViewState) {
    }
}
