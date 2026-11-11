import UIKit

final class RestaurantCell: UITableViewCell {

    static let reuseIdentifier = "RestaurantCell"

    private let photoView = UIImageView()
    private let nameLabel = UILabel()
    private let detailLabel = UILabel()
    private let starsStack = UIStackView()
    private let statusDot = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        photoView.contentMode = .scaleAspectFit
        photoView.tintColor = UIColor(named: "AccentColor")
        photoView.backgroundColor = .secondarySystemBackground
        photoView.layer.cornerRadius = 12
        photoView.clipsToBounds = true

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.numberOfLines = 0
        detailLabel.font = .preferredFont(forTextStyle: .footnote)
        detailLabel.adjustsFontForContentSizeCategory = true
        detailLabel.numberOfLines = 0
        detailLabel.textColor = .secondaryLabel

        starsStack.axis = .horizontal
        starsStack.spacing = 2

        statusDot.layer.cornerRadius = 5

        // VoiceOver reads the whole cell as one element (see configure).
        isAccessibilityElement = true

        let textStack = UIStackView(arrangedSubviews: [nameLabel, detailLabel, starsStack])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading

        [photoView, textStack, statusDot].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            photoView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            photoView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            photoView.widthAnchor.constraint(equalToConstant: 64),
            photoView.heightAnchor.constraint(equalToConstant: 64),

            textStack.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 12),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12),
            textStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: statusDot.leadingAnchor, constant: -8),

            statusDot.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusDot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusDot.widthAnchor.constraint(equalToConstant: 10),
            statusDot.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func configure(with restaurant: Restaurant) {
        photoView.image = UIImage(systemName: restaurant.imageName)
        nameLabel.text = restaurant.name
        detailLabel.text = "\(restaurant.cuisine) · \(restaurant.deliveryMinutes) min · \(PriceFormatter.string(from: restaurant.deliveryFee)) delivery"

        starsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let fullStars = Int(restaurant.rating.rounded())
        for index in 0..<5 {
            let star = UIImageView(image: UIImage(systemName: index < fullStars ? "star.fill" : "star"))
            star.tintColor = .systemOrange
            star.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: .footnote)
            star.isAccessibilityElement = false
            starsStack.addArrangedSubview(star)
        }

        statusDot.backgroundColor = restaurant.isOpen ? .systemGreen : .systemRed

        let ratingText = "Rated \(String(format: "%.1f", restaurant.rating)) out of 5"
        let statusText = restaurant.isOpen ? "Open now" : "Closed"
        accessibilityLabel = [
            restaurant.name,
            restaurant.cuisine,
            "\(restaurant.deliveryMinutes) minutes",
            "\(PriceFormatter.string(from: restaurant.deliveryFee)) delivery",
            ratingText,
            statusText
        ].joined(separator: ", ")
    }
}
