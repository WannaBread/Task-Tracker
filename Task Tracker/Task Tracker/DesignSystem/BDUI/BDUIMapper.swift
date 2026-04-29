import UIKit

typealias BDUIActionHandler = (BDUIAction) -> Void

protocol BDUIMapperProtocol {
    func map(_ component: BDUIComponent, actionHandler: @escaping BDUIActionHandler) -> UIView
}

// MARK: - BDUIMapper

final class BDUIMapper: BDUIMapperProtocol {

    // MARK: - BDUIMapperProtocol

    func map(_ component: BDUIComponent, actionHandler: @escaping BDUIActionHandler) -> UIView {
        let built: UIView
        switch component {
        case .stackView(let payload):   built = makeStackView(payload, actionHandler: actionHandler)
        case .label(let payload):       built = makeLabel(payload)
        case .button(let payload):      built = makeButton(payload, actionHandler: actionHandler)
        case .textField(let payload):   built = makeTextField(payload)
        case .imageView(let payload):   built = makeImageView(payload)
        }
        guard let padding = component.padding else { return built }
        return wrap(built, padding: padding)
    }

    private func wrap(_ view: UIView, padding: BDUIPadding) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: container.topAnchor, constant: padding.top?.cgFloat ?? 0),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -(padding.bottom?.cgFloat ?? 0)),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding.leading?.cgFloat ?? 0),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -(padding.trailing?.cgFloat ?? 0)),
        ])
        return container
    }

    // MARK: - Private Makers

    private func makeStackView(
        _ payload: BDUIStackViewPayload,
        actionHandler: @escaping BDUIActionHandler
    ) -> UIView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false

        switch payload.axis {
        case .horizontal: stack.axis = .horizontal
        case .vertical:   stack.axis = .vertical
        }

        stack.spacing = payload.spacing?.cgFloat ?? DS.Spacing.m

        switch payload.alignment ?? .fill {
        case .fill:     stack.alignment = .fill
        case .center:   stack.alignment = .center
        case .leading:  stack.alignment = .leading
        case .trailing: stack.alignment = .trailing
        }

        for child in payload.children {
            let childView = map(child, actionHandler: actionHandler)
            stack.addArrangedSubview(childView)
        }

        return stack
    }

    private func makeLabel(_ payload: BDUILabelPayload) -> UIView {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = payload.numberOfLines ?? 0
        let style = payload.style?.dsTextStyle ?? .body
        let color = payload.color?.uiColor ?? DS.Colors.textPrimary
        label.apply(style, color: color)
        label.text = payload.text
        return label
    }

    private func makeButton(
        _ payload: BDUIButtonPayload,
        actionHandler: @escaping BDUIActionHandler
    ) -> UIView {
        let button = DSButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(with: DSButtonConfig(
            title: payload.title,
            style: payload.style?.dsButtonStyle ?? .primary,
            onTap: { actionHandler(payload.action) }
        ))
        return button
    }

    private func makeTextField(_ payload: BDUITextFieldPayload) -> UIView {
        let field = DSTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        let config = DSFieldConfig(
            title: payload.title ?? "",
            placeholder: payload.placeholder,
            isSecure: payload.isSecure ?? false
        )
        field.configure(with: config)
        return field
    }

    private func makeImageView(_ payload: BDUIImageViewPayload) -> UIView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: payload.systemName)
        imageView.tintColor = payload.tintColor?.uiColor ?? DS.Colors.primary
        let size = payload.size ?? 24
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: size),
            imageView.heightAnchor.constraint(equalToConstant: size),
        ])
        return imageView
    }

}
