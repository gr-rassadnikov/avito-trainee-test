import Foundation
import UIKit
import DomainModels
import UIComponents
import SAL

public protocol ProductViewControllerDelegate {
    func presentProductViewController(on presentingViewController: UIViewController, with productID: Int)
}

public class ProductViewController : UIViewController {

    private enum State {
        case show(Product)
        case load
        case error(Error)
        case none(String)
    }

    private var state: State {
        willSet {
            switch newValue {
            case .show(let product):
                loadingView.isHidden = true
                imageView.isHidden = false
                titleLabel.isHidden = false
                priceLabel.isHidden = false
                locationLabel.isHidden = false
                dateLabel.isHidden = false
                descriptionLabel.isHidden = false
                adressLabel.isHidden = false
                phoneLabel.isHidden = false

                titleLabel.text = product.title
                priceLabel.text = product.price
                locationLabel.text = product.location
                dateLabel.text = product.createdDate
                descriptionLabel.text = product.description
                adressLabel.text = product.address
                phoneLabel.text = product.phoneNumber

                client.loadImage(url: product.imageUrl) { [weak self] result in
                    switch result {
                    case .success(let image):
                        self?.imageView.image = image
                    case .failure:
                        self?.imageView.image = nil
                    }
                }
            case .load:
                loadingView.isHidden = false
                imageView.isHidden = true
                titleLabel.isHidden = true
                priceLabel.isHidden = true
                locationLabel.isHidden = true
                dateLabel.isHidden = true
                descriptionLabel.isHidden = true
                adressLabel.isHidden = true
                phoneLabel.isHidden = true
            case .error:
                break
            case .none:
                break
            }
        }
    }

    private let client: ProductProvider & ImagesProvider = AvitoClient()

    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.bgProductCard
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textColor
        label.font = Fonts.textProductTitle
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textColor
        label.font = Fonts.textProductPrice
        return label
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textMinorColor
        label.font = Fonts.textProductInfo
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textMinorColor
        label.font = Fonts.textProductInfo
        label.textAlignment = .right
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textColor
        label.font = Fonts.textProductInfo
        label.numberOfLines = 0
        return label
    }()

    private lazy var adressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textMinorColor
        label.font = Fonts.textProductInfo
        return label
    }()

    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.textColor
        label.font = Fonts.textProductPhone
        return label
    }()

    public init(productID: String) {
        state = .none(productID)

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        super.loadView()
        
        switch state {
        case.none(let productId):
            client.product(productId: productId) { [weak self] result in
                switch result {
                case .success(let product):
                    self?.state = .show(product)
                case .failure(let error):
                    self?.state = .error(error)
                }
            }
        case .load, .show, .error:
            break
        }

        state = .load
        view.backgroundColor = Colors.bgProductCard

    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(loadingView)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(locationLabel)
        view.addSubview(dateLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(adressLabel)
        view.addSubview(phoneLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            priceLabel.heightAnchor.constraint(equalToConstant: 20),

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),

            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            locationLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -12),
            locationLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),

            adressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            adressLabel.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -12),
            adressLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            adressLabel.heightAnchor.constraint(equalToConstant: 20),

            dateLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),


            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            phoneLabel.topAnchor.constraint(equalTo: adressLabel.bottomAnchor, constant: 12),
            phoneLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    

}
