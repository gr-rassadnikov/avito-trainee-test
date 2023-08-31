import Foundation
import UIKit
import DomainModels
import UIComponents
import SAL
import Product

public class MarketViewController : UIViewController {

    private enum State {
        case show(Market)
        case load
        case error(Error)
    }

    private var state: State = .load {
        willSet {
            switch newValue {
            case .show:
                loadingView.isHidden = true
                titleLabel.isHidden = false
                collectionView.isHidden = false
                collectionView.reloadData()
            case .load:
                loadingView.isHidden = false
                titleLabel.isHidden = true
                collectionView.isHidden = true
            case .error:
                loadingView.isHidden = false
                titleLabel.isHidden = false
                collectionView.isHidden = true
            }
        }
    }

    private var market: Market? {
        get {
            switch state {
            case .show(let market):
                return market
            case .error, .load:
                return nil
            }
        }
        set {}
    }

    private let client: MarketProvider & ImagesProvider = AvitoClient()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Colors.background
        return collectionView
    }()

    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Texts.marketTitle
        label.font = Fonts.textMainTitle
        label.textColor = Colors.textColor
        return label
    }()

    public override func loadView() {
        super.loadView()

        state = .load

        client.market() { result in
            switch result {
            case .success(let market):
                self.state = .show(market)
            case .failure(let error):
                self.state = .error(error)
            }
        }
        view.backgroundColor = Colors.background

    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        addSubviews()
        setupConstraints()
    }

    private func configureViews() {
        collectionView.register(MarketCollectionViewCell.self, forCellWithReuseIdentifier: MarketCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func addSubviews() {
        view.addSubview(loadingView)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
        ])
    }

    private func presentProductViewController(with productID: String?) {
        guard let id = productID else { return }
        let vc = ProductViewController(productID: id)
        present(vc, animated: true)
    }

}

extension MarketViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return market?.advertisements.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarketCollectionViewCell.identifier,
            for: indexPath
        )

        guard let cell = cell as? MarketCollectionViewCell else {
            return cell
        }
        guard let advertisement = market?.advertisements[indexPath.row] else { return cell }

        cell.setup(with: advertisement)
        let id = advertisement.id
        let row = indexPath.row
        if advertisement.image == nil {
            client.loadImage(url: advertisement.imageUrl) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.market?.advertisements[row].image = image
                    cell.setupImage(image: image, id: id)
                case .failure:
                    break
                }
            }
        }
        return cell
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 2 - 18,
                      height: 235)
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 3
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 16
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1,
                            left: 1,
                            bottom: 1,
                            right: 1)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        print(market?.advertisements[indexPath.row])
        presentProductViewController(with: market?.advertisements[indexPath.row].id)
    }
}
