import UIKit
import DomainModels
import UIComponents
import SAL

final class MarketCollectionViewCell: UICollectionViewCell {
    static let identifier = "MarketCollectionViewCell"

    private var id: String?

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white //
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textColor
        label.font = Fonts.textTitle
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textColor
        label.font = Fonts.textPrice
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textMinorColor
        label.font = Fonts.textCreateProductInfo
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textMinorColor
        label.font = Fonts.textCreateProductInfo
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = Colors.bgProductCard

        addSubviews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
           fatalError()
    }

    func setup(with advertisement: Market.Advertisement) {
        titleLabel.text = advertisement.title
        priceLabel.text = advertisement.price
        locationLabel.text = advertisement.location
        dateLabel.text = advertisement.createdDate
        imageView.image = advertisement.image
        id = advertisement.id
    }

    func setupImage(image: UIImage, id: String) {
        guard self.id == id else { return }
        imageView.image = image
    }

    private func addSubviews() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),

            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            priceLabel.heightAnchor.constraint(equalToConstant: 20),

            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            locationLabel.heightAnchor.constraint(equalToConstant: 10),

            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 3),
            dateLabel.heightAnchor.constraint(equalToConstant: 10),

        ])
    }

}
