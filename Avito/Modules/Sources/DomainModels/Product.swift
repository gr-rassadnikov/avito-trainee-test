import Foundation

public struct Product {
    public let id: String
    public let title: String
    public let price: String
    public let location: String
    public let imageUrl: String
    public let createdDate: String
    public let description: String
    public let email: String
    public let phoneNumber: String
    public let address: String

    public init(
        id: String,
        title: String,
        price: String,
        location: String,
        imageUrl: String,
        createdDate: String,
        description: String,
        email: String,
        phoneNumber: String,
        address: String
    ) {
        self.id = id
        self.title = title
        self.price = price
        self.location = location
        self.imageUrl = imageUrl
        self.createdDate = createdDate
        self.description = description
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
    }
}
