import UIKit

final class DSButton: UIControl {

    // MARK: - Private subviews

    private let label = UILabel()
    private let iconView = UIImageView()
    private let spinner = UIActivityIndicatorView(style: .medium)

    // MARK: - State

    private var currentConfig: DSButtonConfig?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyBaseStyle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Base style (called once)

    private func applyBaseStyle() {
        layer.cornerRadius = DS.Spacing.cornerRadius

        label.font = DS.Typography.button()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false

        addSubview(iconView)
        addSubview(label)
        addSubview(spinner)

        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: DS.Cell.iconSize),
            iconView.heightAnchor.constraint(equalToConstant: DS.Cell.iconSize),

            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: DS.Spacing.m),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -DS.Spacing.m),

            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
    }

    // MARK: - Configure

    func configure(with config: DSButtonConfig) {

        currentConfig = config

        applyVisualStyle(config.style)

        if config.isLoading {
            label.isHidden = true
            iconView.isHidden = true
            spinner.startAnimating()
            isUserInteractionEnabled = false
            alpha = 1.0
        } else {
            spinner.stopAnimating()
            label.text = config.title
            label.isHidden = false
            if let icon = config.icon {
                iconView.image = icon
                iconView.isHidden = false
                label.isHidden = true
            } else {
                iconView.isHidden = true
            }
            isUserInteractionEnabled = config.isEnabled
            alpha = config.isEnabled ? 1.0 : DS.Animation.disabledAlpha
        }
    }

    // MARK: - Private helpers

    private func applyVisualStyle(_ style: DSButtonConfig.Style) {
        switch style {
        case .primary:
            backgroundColor = DS.Colors.primary
            label.textColor = DS.Colors.buttonText
            iconView.tintColor = DS.Colors.buttonText
            spinner.color = DS.Colors.buttonText
            layer.borderWidth = 0
        case .secondary:
            backgroundColor = .clear
            label.textColor = DS.Colors.primary
            iconView.tintColor = DS.Colors.primary
            spinner.color = DS.Colors.primary
            layer.borderWidth = DS.Button.secondaryBorderWidth
            layer.borderColor = DS.Colors.primary.cgColor
        case .destructive:
            backgroundColor = DS.Colors.error
            label.textColor = DS.Colors.buttonText
            iconView.tintColor = DS.Colors.buttonText
            spinner.color = DS.Colors.buttonText
            layer.borderWidth = 0
        }
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
        let isEnabled = currentConfig?.isEnabled ?? true
        let isLoading = currentConfig?.isLoading ?? false
        let targetAlpha: CGFloat = (!isEnabled || isLoading) ? DS.Animation.disabledAlpha : 1.0
        UIView.animate(withDuration: DS.Animation.tapDuration) { self.alpha = targetAlpha }
    }
}
