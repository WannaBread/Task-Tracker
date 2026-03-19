import UIKit

final class AuthView: UIView {
    weak var delegate: AuthViewDelegate?

    // MARK: - Layout Constants

    private enum Layout {
        static let cornerRadius: CGFloat = 12
        static let fieldHeight: CGFloat = 50
        static let buttonHeight: CGFloat = 50
        static let horizontalPadding: CGFloat = 24
        static let fieldInnerPadding: CGFloat = 16
        static let topPadding: CGFloat = 240
        static let bottomPadding: CGFloat = 40
        static let titleToSubtitleSpacing: CGFloat = 8
        static let subtitleToEmailSpacing: CGFloat = 40
        static let fieldToErrorSpacing: CGFloat = 4
        static let emailErrorToPasswordSpacing: CGFloat = 12
        static let passwordErrorToGeneralErrorSpacing: CGFloat = 16
        static let generalErrorToButtonSpacing: CGFloat = 24
        static let spinnerTrailingInset: CGFloat = 16
        static let disabledAlpha: CGFloat = 0.6
        static let fieldBorderWidth: CGFloat = 1.5
    }

    // MARK: - UI Elements

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.keyboardDismissMode = .interactive
        sv.alwaysBounceVertical = true
        return sv
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let formStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Task Tracker"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "auth_title_label"
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to continue"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "auth_subtitle_label"
        return label
    }()

    private let emailTextField: UITextField = {
        let tf = makeStyledTextField(placeholder: "Email", identifier: "auth_email_field")
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .next
        return tf
    }()

    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "auth_email_error_label"
        return label
    }()

    private let passwordTextField: UITextField = {
        let tf = makeStyledTextField(placeholder: "Password", identifier: "auth_password_field")
        tf.isSecureTextEntry = true
        tf.returnKeyType = .go
        return tf
    }()

    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "auth_password_error_label"
        return label
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "auth_error_label"
        return label
    }()

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Layout.cornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "auth_login_button"
        return button
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    // MARK: - Init

    init(delegate: AuthViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupLayout()
        setupActions()
        setupKeyboardObservers()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Factory Helpers

    private static func makeStyledTextField(placeholder: String, identifier: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.accessibilityIdentifier = identifier
        tf.backgroundColor = .secondarySystemBackground
        tf.layer.cornerRadius = Layout.cornerRadius
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Layout.fieldInnerPadding, height: 0))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: Layout.fieldInnerPadding, height: 0))
        tf.rightViewMode = .always
        return tf
    }

    // MARK: - Layout

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(formStack)
        loginButton.addSubview(spinner)

        // Build the vertical form stack
        formStack.addArrangedSubview(titleLabel)
        formStack.setCustomSpacing(Layout.titleToSubtitleSpacing, after: titleLabel)

        formStack.addArrangedSubview(subtitleLabel)
        formStack.setCustomSpacing(Layout.subtitleToEmailSpacing, after: subtitleLabel)

        formStack.addArrangedSubview(emailTextField)
        formStack.setCustomSpacing(Layout.fieldToErrorSpacing, after: emailTextField)

        formStack.addArrangedSubview(emailErrorLabel)
        formStack.setCustomSpacing(Layout.emailErrorToPasswordSpacing, after: emailErrorLabel)

        formStack.addArrangedSubview(passwordTextField)
        formStack.setCustomSpacing(Layout.fieldToErrorSpacing, after: passwordTextField)

        formStack.addArrangedSubview(passwordErrorLabel)
        formStack.setCustomSpacing(Layout.passwordErrorToGeneralErrorSpacing, after: passwordErrorLabel)

        formStack.addArrangedSubview(errorLabel)
        formStack.setCustomSpacing(Layout.generalErrorToButtonSpacing, after: errorLabel)

        formStack.addArrangedSubview(loginButton)

        NSLayoutConstraint.activate([
            // ScrollView → fills the safe area
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Content view → fills scrollView, matches width
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Form stack → centered with horizontal padding
            formStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.topPadding),
            formStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.horizontalPadding),
            formStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.horizontalPadding),
            formStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.bottomPadding),

            // Fixed heights for text fields and button
            emailTextField.heightAnchor.constraint(equalToConstant: Layout.fieldHeight),
            passwordTextField.heightAnchor.constraint(equalToConstant: Layout.fieldHeight),
            loginButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),

            // Spinner inside button
            spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            spinner.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: -Layout.spinnerTrailingInset),
        ])
    }

    // MARK: - Actions

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        emailTextField.delegate = self
        passwordTextField.delegate = self

        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    @objc private func loginTapped() {
        delegate?.authViewDidTapLogin(
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        clearFieldError(for: textField)
    }

    // MARK: - Keyboard Handling

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let keyboardInView = convert(endFrame, from: nil)
        let intersection = bounds.intersection(keyboardInView)
        let bottomInset = intersection.isNull ? 0 : intersection.height

        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0.25
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = bottomInset
            self.scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        }
    }

    // MARK: - Update State

    func update(with state: AuthViewState) {
        loginButton.isEnabled = state.isLoginButtonEnabled
        loginButton.alpha = state.isLoginButtonEnabled ? 1.0 : Layout.disabledAlpha

        if state.isLoading {
            spinner.startAnimating()
            loginButton.setTitle("", for: .normal)
        } else {
            spinner.stopAnimating()
            loginButton.setTitle("Sign In", for: .normal)
        }

        // Update email field error only if changed
        if let emailErr = state.emailError {
            showFieldError(for: emailTextField, label: emailErrorLabel, message: emailErr)
        } else {
            clearFieldError(for: emailTextField)
        }

        // Update password field error only if changed
        if let passwordErr = state.passwordError {
            showFieldError(for: passwordTextField, label: passwordErrorLabel, message: passwordErr)
        } else {
            clearFieldError(for: passwordTextField)
        }

        // Show or hide general error
        if let error = state.errorText {
            errorLabel.text = error
            errorLabel.isHidden = false
        } else {
            errorLabel.text = nil
            errorLabel.isHidden = true
        }
    }

    // MARK: - Field Validation Helpers

    private func showFieldError(for field: UITextField, label: UILabel, message: String) {
        field.layer.borderWidth = Layout.fieldBorderWidth
        field.layer.borderColor = UIColor.systemRed.cgColor
        label.text = message
        label.isHidden = false
    }

    private func clearFieldError(for textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = nil
        if textField === emailTextField {
            emailErrorLabel.text = nil
            emailErrorLabel.isHidden = true
        } else if textField === passwordTextField {
            passwordErrorLabel.text = nil
            passwordErrorLabel.isHidden = true
        }
    }
}

// MARK: - UITextFieldDelegate

extension AuthView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField === passwordTextField {
            passwordTextField.resignFirstResponder()
            loginTapped()
        }
        return true
    }
}
