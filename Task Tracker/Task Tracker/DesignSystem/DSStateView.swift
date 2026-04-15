import UIKit

enum DSStateViewKind {
    case loading(message: String?)
    case error(message: String, retryTitle: String?)
    case empty(message: String, image: UIImage?)
}

final class DSStateView: UIView {

    var onRetry: (() -> Void)?

    // MARK: - Subviews

    private let spinner: UIActivityIndicatorView = {
        let s = UIActivityIndicatorView(style: .large)
        s.hidesWhenStopped = true
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font = DS.Typography.body()
        l.textColor = DS.Colors.textSecondary
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var retryButton: DSButton = {
        let btn = DSButton(style: .secondary, title: "Повторить")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return btn
    }()

    private let contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = DS.Spacing.m
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Layout

    private func setup() {
        contentStack.addArrangedSubview(spinner)
        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(messageLabel)
        contentStack.addArrangedSubview(retryButton)

        addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DS.Spacing.l),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DS.Spacing.l),

            retryButton.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            retryButton.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor),

            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: DS.StateView.maxImageSize),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: DS.StateView.maxImageSize),
        ])
    }

    // MARK: - Configure

    func configure(with kind: DSStateViewKind) {
        spinner.stopAnimating()
        spinner.isHidden = true
        imageView.isHidden = true
        messageLabel.isHidden = true
        retryButton.isHidden = true

        switch kind {
        case .loading(let message):
            spinner.isHidden = false
            spinner.startAnimating()
            if let message {
                messageLabel.text = message
                messageLabel.font = DS.Typography.body()
                messageLabel.textColor = DS.Colors.textSecondary
                messageLabel.isHidden = false
            }

        case .error(let message, let retryTitle):
            messageLabel.text = message
            messageLabel.font = DS.Typography.body()
            messageLabel.textColor = DS.Colors.error
            messageLabel.isHidden = false
            if let retryTitle {
                retryButton.setTitle(retryTitle)
                retryButton.isHidden = false
            }

        case .empty(let message, let image):
            if let image {
                imageView.image = image
                imageView.isHidden = false
            }
            messageLabel.text = message
            messageLabel.font = DS.Typography.bodyMedium()
            messageLabel.textColor = DS.Colors.textSecondary
            messageLabel.isHidden = false
        }
    }

    // MARK: - Actions

    @objc private func retryTapped() {
        onRetry?()
    }
}
