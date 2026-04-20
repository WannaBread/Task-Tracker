import UIKit

final class AuthView: UIView {
    weak var delegate: AuthViewDelegate?

    private var emailDebounceWork: DispatchWorkItem?
    private var passwordDebounceWork: DispatchWorkItem?

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
        label.apply(.largeTitle)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "auth_title_label"
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in to continue"
        label.apply(.body, color: DS.Colors.textSecondary)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "auth_subtitle_label"
        return label
    }()

    private let emailField: DSTextField = {
        let f = DSTextField()
        f.configure(with: DSFieldConfig(
            title: "Email",
            placeholder: "Введите email",
            keyboardType: .emailAddress,
            autocapitalization: .none,
            autocorrection: .no,
            returnKeyType: .next
        ))
        f.accessibilityIdentifierForField = "auth_email_field"
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()

    private let passwordField: DSTextField = {
        let f = DSTextField()
        f.configure(with: DSFieldConfig(
            title: "Пароль",
            placeholder: "Введите пароль",
            isSecure: true,
            returnKeyType: .go
        ))
        f.accessibilityIdentifierForField = "auth_password_field"
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.apply(.captionMedium, color: DS.Colors.error)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "auth_error_label"
        return label
    }()

    private let loginButton: DSButton = {
        let btn = DSButton()
        btn.configure(with: DSButtonConfig(title: "Sign In", style: .primary))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.accessibilityIdentifier = "auth_login_button"
        return btn
    }()

    // MARK: - Init

    init(delegate: AuthViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = DS.Colors.background
        setupLayout()
        setupActions()
        setupKeyboardObservers()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(formStack)

        formStack.addArrangedSubview(titleLabel)
        formStack.setCustomSpacing(DS.Spacing.s, after: titleLabel)

        formStack.addArrangedSubview(subtitleLabel)
        formStack.setCustomSpacing(DS.Spacing.xl, after: subtitleLabel)

        formStack.addArrangedSubview(emailField)
        formStack.setCustomSpacing(DS.Spacing.m, after: emailField)

        formStack.addArrangedSubview(passwordField)
        formStack.setCustomSpacing(DS.Spacing.m, after: passwordField)

        formStack.addArrangedSubview(errorLabel)
        formStack.setCustomSpacing(DS.Spacing.l, after: errorLabel)

        formStack.addArrangedSubview(loginButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            formStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Spacing.pageTopOffset),
            formStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.l),
            formStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.l),
            formStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DS.Spacing.xl),

            loginButton.heightAnchor.constraint(equalToConstant: DS.Spacing.buttonHeight),
        ])
    }

    // MARK: - Actions

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        emailField.textFieldDelegate = self
        passwordField.textFieldDelegate = self

        emailField.onTextChanged = { [weak self] text in
            guard let self else { return }
            self.emailField.state = .normal
            self.emailDebounceWork?.cancel()
            let work = DispatchWorkItem { [weak self] in
                self?.delegate?.authViewDidChangeEmail(text)
            }
            self.emailDebounceWork = work
            DispatchQueue.main.asyncAfter(deadline: .now() + DS.Animation.debounceDelay, execute: work)
        }

        passwordField.onTextChanged = { [weak self] text in
            guard let self else { return }
            self.passwordField.state = .normal
            self.passwordDebounceWork?.cancel()
            let work = DispatchWorkItem { [weak self] in
                self?.delegate?.authViewDidChangePassword(text)
            }
            self.passwordDebounceWork = work
            DispatchQueue.main.asyncAfter(deadline: .now() + DS.Animation.debounceDelay, execute: work)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    @objc private func loginTapped() {
        delegate?.authViewDidTapLogin(
            email: emailField.text,
            password: passwordField.text
        )
    }

    @objc private func dismissKeyboard() {
        endEditing(true)
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

        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? DS.Animation.keyboardFallbackDuration
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = bottomInset
            self.scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
        }
    }

    // MARK: - Update State

    func update(with state: AuthViewState) {
        loginButton.configure(with: DSButtonConfig(
            title: "Sign In",
            style: .primary,
            isEnabled: state.isLoginButtonEnabled,
            isLoading: state.isLoading
        ))

        emailField.state = state.emailError.map { .error($0) } ?? .normal
        passwordField.state = state.passwordError.map { .error($0) } ?? .normal

        if let error = state.errorText {
            errorLabel.text = error
            errorLabel.isHidden = false
        } else {
            errorLabel.text = nil
            errorLabel.isHidden = true
        }
    }

    // MARK: - Field Validation (real-time)

    func updateEmailValidation(error: String?) {
        emailField.state = error.map { .error($0) } ?? .normal
    }

    func updatePasswordValidation(error: String?) {
        passwordField.state = error.map { .error($0) } ?? .normal
    }
}

// MARK: - UITextFieldDelegate

extension AuthView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === emailField.textField {
            passwordField.becomeFirstResponder()
        } else if textField === passwordField.textField {
            passwordField.resignFirstResponder()
            loginTapped()
        }
        return true
    }
}
