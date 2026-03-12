import UIKit

final class AuthView: UIView {
    weak var delegate: AuthViewDelegate?

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
        return label
    }()

    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .none
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .next
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.accessibilityIdentifier = "auth_email_field"
        tf.backgroundColor = .secondarySystemBackground
        tf.layer.cornerRadius = 12
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.rightViewMode = .always
        return tf
    }()

    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .none
        tf.isSecureTextEntry = true
        tf.returnKeyType = .go
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.accessibilityIdentifier = "auth_password_field"
        tf.backgroundColor = .secondarySystemBackground
        tf.layer.cornerRadius = 12
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.rightViewMode = .always
        return tf
    }()

    private let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemRed
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
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
        button.layer.cornerRadius = 12
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Layout

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(emailErrorLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(passwordErrorLabel)
        contentView.addSubview(errorLabel)
        contentView.addSubview(loginButton)
        loginButton.addSubview(spinner)

        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            // Email
            emailTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            // Email error
            emailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 4),
            emailErrorLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 4),
            emailErrorLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),

            // Password
            passwordTextField.topAnchor.constraint(equalTo: emailErrorLabel.bottomAnchor, constant: 12),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            // Password error
            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 4),
            passwordErrorLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

            // Error label
            errorLabel.topAnchor.constraint(equalTo: passwordErrorLabel.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            // Login button
            loginButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),

            // Spinner
            spinner.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            spinner.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: -16),
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
        loginButton.alpha = state.isLoginButtonEnabled ? 1.0 : 0.6

        if state.isLoading {
            spinner.startAnimating()
            loginButton.setTitle("", for: .normal)
        } else {
            spinner.stopAnimating()
            loginButton.setTitle("Sign In", for: .normal)
        }

        if let error = state.errorText {
            if error.contains("email") || error.contains("Email") {
                showFieldError(for: emailTextField, label: emailErrorLabel, message: "Enter a valid email")
            }
            if error.contains("Password") || error.contains("password") || error.contains("6 characters") {
                showFieldError(for: passwordTextField, label: passwordErrorLabel, message: "Min. 6 characters")
            }

            if error.contains("Invalid email or password") ||
                error.contains("Authentication failed") ||
                error.contains("Unknown error") {
                errorLabel.text = error
                errorLabel.isHidden = false
            }
        } else {
            errorLabel.isHidden = true
            clearFieldError(for: emailTextField)
            clearFieldError(for: passwordTextField)
        }
    }

    // MARK: - Field Validation Helpers

    private func showFieldError(for field: UITextField, label: UILabel, message: String) {
        field.layer.borderWidth = 1.5
        field.layer.borderColor = UIColor.systemRed.cgColor
        label.text = message
        label.isHidden = false
    }

    private func clearFieldError(for textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.layer.borderColor = nil
        if textField === emailTextField {
            emailErrorLabel.isHidden = true
        } else if textField === passwordTextField {
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
