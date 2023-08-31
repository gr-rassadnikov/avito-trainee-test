import Foundation

public protocol DecodableFromDTO {
    associatedtype DTO: Decodable
    init(from dto: DTO)
}

public extension JSONDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : DecodableFromDTO {
        try T(from: decode(T.DTO.self, from: data))
    }
}
