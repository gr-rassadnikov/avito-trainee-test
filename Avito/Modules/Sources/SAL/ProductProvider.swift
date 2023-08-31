import DomainModels

public protocol ProductProvider {
    func product(productId: String, completion: @escaping (_: Result<Product, Error>) -> Void)
}
