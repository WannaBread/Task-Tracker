import UIKit

final class TaskListCell: UITableViewCell {
    static let reuseIdentifier = "TaskListCell"

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.apply(.bodyMedium)
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.apply(.caption, color: DS.Colors.textSecondary)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let iconsStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = DS.Spacing.xs
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Layout

    private func setupUI() {
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = DS.Cell.textStackSpacing
        textStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(textStack)
        contentView.addSubview(iconsStack)

        NSLayoutConstraint.activate([
            iconsStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Cell.verticalPadding),
            iconsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DS.Spacing.m),
            iconsStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -DS.Cell.verticalPadding),

            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DS.Cell.verticalPadding),
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DS.Spacing.m),
            textStack.trailingAnchor.constraint(equalTo: iconsStack.leadingAnchor, constant: -DS.Spacing.s),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -DS.Cell.verticalPadding),
        ])
    }

    // MARK: - Configure

    func configure(with viewModel: TaskCellViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.titleColor

        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle.isEmpty

        rebuildIcons(viewModel.icons)
    }

    private func rebuildIcons(_ configs: [TaskCellViewModel.IconConfig]) {
        iconsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for config in configs {
            let iv = UIImageView(image: config.image)
            iv.tintColor = config.tintColor
            iv.contentMode = .scaleAspectFit
            iv.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iv.widthAnchor.constraint(equalToConstant: DS.Cell.iconSize),
                iv.heightAnchor.constraint(equalToConstant: DS.Cell.iconSize),
            ])
            iconsStack.addArrangedSubview(iv)
        }
    }

    // MARK: - Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleLabel.textColor = DS.Colors.textPrimary
        subtitleLabel.text = nil
        subtitleLabel.isHidden = false
        iconsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
