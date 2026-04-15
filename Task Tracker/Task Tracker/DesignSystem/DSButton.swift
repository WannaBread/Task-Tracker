import UIKit

final class DSButton: UIControl {

    enum Style {
        case primary
        case secondary
        case destructive
    }

    // MARK: - Private

    private let style: Style
    private let label = UILabel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private var storedTitle: String = ""

    // MARK: - Init

    init(style: Style, title: String = "") {
        self.style = style
        self.storedTitle = title
        super.init(frame: .zero)
        setup()
        setTitle(title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = DS.Spacing.cornerRadius

        label.font = DS.Typography.button()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true

        addSubview(label)
        addSubview(spinner)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: DS.Spacing.m),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -DS.Spacing.m),

            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        applyStyle()

        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
    }

    private func applyStyle() {
        switch style {
        case .primary:
            backgroundColor = DS.Colors.primary
            label.textColor = DS.Colors.buttonText
            spinner.color = DS.Colors.buttonText
            layer.borderWidth = 0
        case .secondary:
            backgroundColor = .clear
            label.textColor = DS.Colors.primary
            spinner.color = DS.Colors.primary
            layer.borderWidth = DS.Button.secondaryBorderWidth
            layer.borderColor = DS.Colors.primary.cgColor
        case .destructive:
            backgroundColor = DS.Colors.error
            label.textColor = DS.Colors.buttonText
            spinner.color = DS.Colors.buttonText
            layer.borderWidth = 0
        }
    }

    // MARK: - Public API

    func setTitle(_ title: String) {
        storedTitle = title
        label.text = title
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            label.text = ""
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
            label.text = storedTitle
        }
        isUserInteractionEnabled = !isLoading
    }

    // MARK: - Enabled state

    override var isEnabled: Bool {
        didSet { alpha = isEnabled ? 1.0 : DS.Animation.disabledAlpha }
    }

    // MARK: - intrinsicContentSize

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: DS.Spacing.buttonHeight)
    }

    // MARK: - Touch feedback

    @objc private func touchDown() {
        UIView.animate(withDuration: DS.Animation.tapDuration) { self.alpha = DS.Animation.tapAlpha }
    }

    @objc private func touchUp() {
        UIView.animate(withDuration: DS.Animation.tapDuration) { self.alpha = self.isEnabled ? 1.0 : DS.Animation.disabledAlpha }
    }
}
