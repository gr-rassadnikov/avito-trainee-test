import Foundation
import DomainModels

extension Product: DecodableFromDTO {
    public struct DTO: Decodable {
        var id: String
        var title: String
        var price: String
        var location: String
        var imageUrl: String
        var createdDate: String
        var description: String
        var email: String
        var phoneNumber: String
        var address: String
    }

    public init(from dto: DTO) {
       self = Product(
        id: dto.id,
        title: dto.title,
        price: dto.price,
        location: dto.location,
        imageUrl: dto.imageUrl,
        createdDate: dto.createdDate,
        description: dto.description,
        email: dto.email,
        phoneNumber: dto.phoneNumber,
        address: dto.address
       )
    }
}
