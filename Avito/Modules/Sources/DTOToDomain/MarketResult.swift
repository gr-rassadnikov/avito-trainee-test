import Foundation
import DomainModels

extension Market: DecodableFromDTO {
    public struct DTO: Decodable {
        struct Advertisement: Decodable {
            var id: String
            var title: String
            var price: String
            var location: String
            var imageUrl: String
            var createdDate: String
        }
        var advertisements: [Advertisement]
    }

    public init(from dto: DTO) {
       self = Market(
        advertisements: dto.advertisements.compactMap({ advertisementResult in
            Market.Advertisement(
                id: advertisementResult.id,
                title: advertisementResult.title,
                price: advertisementResult.price,
                location: advertisementResult.location,
                imageUrl: advertisementResult.imageUrl,
                createdDate: advertisementResult.createdDate
            )
        })
       )
    }
}
