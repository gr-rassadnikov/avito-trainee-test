import DomainModels
import DTOToDomain
import UIKit

public enum ClientError: Error {
    case getRequestError
    case algorithmError
    case decodeJsonError
    case incorrectJsonError
}

public final class AvitoClient: MarketProvider, ProductProvider, ImagesProvider {
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    private let decoder = JSONDecoder()

    public init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    public func market(
        completion: @escaping (_: Result<Market, Error>) -> Void
    ) {
        guard let url = URL(string: UrlComponents.market) else {
            DispatchQueue.main.async {
                completion(.failure(ClientError.decodeJsonError))
            }
            return
        }

        let task = session.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(ClientError.getRequestError))
                }
                return
            }
            print(String(data: data, encoding: .utf8)!)
            do {
                let model = try self.decoder.decode(Market.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(ClientError.decodeJsonError))
                }
                return
            }
        }
        task.resume()
    }

    public func product(
        productId: String,
        completion: @escaping (_: Result<Product, Error>) -> Void
    ) {
        guard let url = URL(string: UrlComponents.product(with: productId)) else {
            DispatchQueue.main.async {
                completion(.failure(ClientError.decodeJsonError))
            }
            return
        }

        let task = session.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(ClientError.getRequestError))
                }
                return
            }
            print(String(data: data, encoding: .utf8)!)
            do {
                let model = try self.decoder.decode(Product.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(ClientError.decodeJsonError))
                }
                return
            }
        }
        task.resume()
    }

    public func loadImage(
        url: String,
        completion: @escaping (_: Result<UIImage, Error>) -> Void
    ) {
        guard let url = URL(string: url) else {
            DispatchQueue.main.async {
                completion(.failure(ClientError.decodeJsonError))
            }
            return
        }

        let task = session.dataTask(with: url) { data, _, _ in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(.failure(ClientError.getRequestError))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
        task.resume()
    }
}

private extension AvitoClient {
    enum UrlComponents {
        static let market = "https://www.avito.st/s/interns-ios/main-page.json"

        static func product(with id: String) -> String {
            "https://www.avito.st/s/interns-ios/details/\(id).json"
        }
    }
}
