import Foundation
import UIKit

public struct Market {
    public var advertisements: [Advertisement]

    public struct Advertisement {
        public let id: String
        public let title: String
        public let price: String
        public let location: String
        public let imageUrl: String
        public let createdDate: String
        public var image: UIImage?

        public init(
            id: String,
            title: String,
            price: String,
            location: String,
            imageUrl: String,
            createdDate: String
        ) {
            self.id = id
            self.title = title
            self.price = price
            self.location = location
            self.imageUrl = imageUrl
            self.createdDate = createdDate
        }
    }

    public init(advertisements: [Advertisement]) {
        self.advertisements = advertisements
    }
}
