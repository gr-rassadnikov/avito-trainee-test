import DomainModels
import UIKit

public protocol ImagesProvider {
    func loadImage(url: String, completion: @escaping (_: Result<UIImage, Error>) -> Void)
}
