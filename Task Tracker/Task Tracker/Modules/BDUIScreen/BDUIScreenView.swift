import UIKit

final class BDUIScreenView: UIView {
    weak var delegate: BDUIScreenViewDelegate?

    // MARK: - Subviews

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isHidden = true
        return sv
    }()

    private let contentContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let stateView: DSStateView = {
        let v = DSStateView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private var currentContentView: UIView?

    // MARK: - Init

    init(delegate: BDUIScreenViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Layout

    private func setupUI() {
        backgroundColor = DS.Colors.background
        scrollView.addSubview(contentContainer)
        addSubview(scrollView)
        addSubview(stateView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stateView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - State API

    func showLoading() {
        scrollView.isHidden = true
        stateView.isHidden = false
        stateView.configure(with: .loading(message: "Загрузка..."))
    }

    func showContent(rootView: UIView) {
        currentContentView?.removeFromSuperview()
        rootView.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(rootView)
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: DS.Spacing.m),
            rootView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: DS.Spacing.m),
            rootView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -DS.Spacing.m),
            rootView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -DS.Spacing.m),
        ])
        currentContentView = rootView
        stateView.isHidden = true
        scrollView.isHidden = false
    }

    func showError(message: String) {
        scrollView.isHidden = true
        stateView.isHidden = false
        stateView.configure(with: .error(message: message, retryTitle: "Повторить"))
        stateView.onRetry = { [weak self] in
            self?.delegate?.bduiScreenViewDidTapRetry()
        }
    }
}
