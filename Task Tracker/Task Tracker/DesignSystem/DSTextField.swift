import UIKit

enum DSFieldState {
    case normal
    case error(String)
    case disabled
}

final class DSTextField: UIView {

    // MARK: - Public API

    var title: String = "" {
        didSet { titleLabel.text = title; titleLabel.isHidden = title.isEmpty }
    }

    var placeholder: String = "" {
        didSet { textField.placeholder = placeholder }
    }

    var state: DSFieldState = .normal {
        didSet { applyState(state) }
    }

    var errorText: String? {
        get {
            if case .error(let msg) = state { return msg }
            return nil
        }
        set { state = newValue.map { .error($0) } ?? .normal }
    }

    var isDisabled: Bool {
        get {
            if case .disabled = state { return true }
            return false
        }
        set { state = newValue ? .disabled : .normal }
    }

    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }

    var isSecure: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }

    var onTextChanged: ((String) -> Void)?

    var keyboardType: UIKeyboardType {
        get { textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    var autocapitalizationType: UITextAutocapitalizationType {
        get { textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }

    var autocorrectionType: UITextAutocorrectionType {
        get { textField.autocorrectionType }
        set { textField.autocorrectionType = newValue }
    }

    var returnKeyType: UIReturnKeyType {
        get { textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }

    var textFieldDelegate: UITextFieldDelegate? {
        get { textField.delegate }
        set { textField.delegate = newValue }
    }

    var accessibilityIdentifierForField: String? {
        get { textField.accessibilityIdentifier }
        set { textField.accessibilityIdentifier = newValue }
    }

    func configure(with config: DSFieldConfig) {
        title = config.title
        placeholder = config.placeholder
        isSecure = config.isSecure
        keyboardType = config.keyboardType
        autocapitalizationType = config.autocapitalization
        autocorrectionType = config.autocorrection
        returnKeyType = config.returnKeyType
    }

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = DS.Typography.small()
        l.textColor = DS.Colors.textSecondary
        l.isHidden = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let fieldContainer: UIView = {
        let v = UIView()
        v.backgroundColor = DS.Colors.secondaryBackground
        v.layer.cornerRadius = DS.Spacing.cornerRadius
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.backgroundColor = .clear
        tf.font = DS.Typography.body()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let errorLabel: UILabel = {
        let l = UILabel()
        l.font = DS.Typography.small()
        l.textColor = DS.Colors.error
        l.numberOfLines = 0
        l.isHidden = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let stack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = DS.Spacing.xs
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Layout

    private func setup() {
        fieldContainer.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
            textField.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor, constant: DS.Spacing.m),
            textField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor, constant: -DS.Spacing.m),
            fieldContainer.heightAnchor.constraint(equalToConstant: DS.Spacing.fieldHeight),
        ])

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(fieldContainer)
        stack.addArrangedSubview(errorLabel)

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
    }

    // MARK: - State

    private func applyState(_ newState: DSFieldState) {
        switch newState {
        case .normal:
            alpha = DS.Animation.fullAlpha
            textField.isUserInteractionEnabled = true
            errorLabel.text = nil
            errorLabel.isHidden = true
            fieldContainer.layer.borderWidth = DS.Button.noBorderWidth
            fieldContainer.layer.borderColor = nil
        case .error(let message):
            alpha = DS.Animation.fullAlpha
            textField.isUserInteractionEnabled = true
            errorLabel.text = message
            errorLabel.isHidden = false
            fieldContainer.layer.borderWidth = DS.Spacing.borderWidth
            fieldContainer.layer.borderColor = DS.Colors.error.cgColor
        case .disabled:
            alpha = DS.Animation.disabledAlpha
            textField.isUserInteractionEnabled = false
            errorLabel.text = nil
            errorLabel.isHidden = true
            fieldContainer.layer.borderWidth = DS.Button.noBorderWidth
            fieldContainer.layer.borderColor = nil
        }
    }

    // MARK: - Actions

    @objc private func textChanged() {
        onTextChanged?(textField.text ?? "")
    }

    // MARK: - First responder forwarding

    @discardableResult
    override func becomeFirstResponder() -> Bool { textField.becomeFirstResponder() }

    @discardableResult
    override func resignFirstResponder() -> Bool { textField.resignFirstResponder() }
}
