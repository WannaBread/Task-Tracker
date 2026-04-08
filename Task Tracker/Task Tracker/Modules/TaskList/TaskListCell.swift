import UIKit

final class TaskListCell: UITableViewCell {
    static let reuseIdentifier = "TaskListCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priorityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let completionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let reminderImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBlue
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let recurrenceImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGreen
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false

        let iconStack = UIStackView(arrangedSubviews: [reminderImageView, recurrenceImageView])
        iconStack.axis = .horizontal
        iconStack.spacing = 4
        iconStack.translatesAutoresizingMaskIntoConstraints = false

        let rightStack = UIStackView(arrangedSubviews: [completionImageView, priorityLabel, iconStack])
        rightStack.axis = .vertical
        rightStack.spacing = 4
        rightStack.alignment = .trailing
        rightStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(textStack)
        contentView.addSubview(rightStack)

        NSLayoutConstraint.activate([
            rightStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            rightStack.widthAnchor.constraint(lessThanOrEqualToConstant: 110),

            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textStack.trailingAnchor.constraint(equalTo: rightStack.leadingAnchor, constant: -8),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),

            completionImageView.widthAnchor.constraint(equalToConstant: 20),
            completionImageView.heightAnchor.constraint(equalToConstant: 20),
            reminderImageView.widthAnchor.constraint(equalToConstant: 16),
            reminderImageView.heightAnchor.constraint(equalToConstant: 16),
            recurrenceImageView.widthAnchor.constraint(equalToConstant: 16),
            recurrenceImageView.heightAnchor.constraint(equalToConstant: 16),
        ])
    }

    func configure(with viewModel: TaskListItemViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = Self.titleColor(for: viewModel.priorityText)
        subtitleLabel.text = viewModel.dueDateText
        subtitleLabel.isHidden = viewModel.dueDateText == nil

        priorityLabel.text = viewModel.priorityText

        let symbolName = viewModel.isCompleted ? "checkmark.circle.fill" : "circle"
        completionImageView.image = UIImage(systemName: symbolName)
        completionImageView.tintColor = viewModel.isCompleted ? .systemGreen : .systemGray3

        reminderImageView.image = viewModel.hasReminder ? UIImage(systemName: "bell.fill") : nil
        reminderImageView.isHidden = !viewModel.hasReminder

        recurrenceImageView.image = viewModel.hasRecurrence ? UIImage(systemName: "repeat") : nil
        recurrenceImageView.isHidden = !viewModel.hasRecurrence
    }

    private static func titleColor(for priorityText: String) -> UIColor {
        switch priorityText {
        case "Low":      return .secondaryLabel
        case "Medium":   return .label
        case "High":     return .systemOrange
        case "Critical": return .systemRed
        default:         return .label
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleLabel.textColor = .label
        subtitleLabel.text = nil
        subtitleLabel.isHidden = false
        priorityLabel.text = nil
        completionImageView.image = nil
        reminderImageView.image = nil
        reminderImageView.isHidden = true
        recurrenceImageView.image = nil
        recurrenceImageView.isHidden = true
    }
}
