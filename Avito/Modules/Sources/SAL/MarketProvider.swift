import DomainModels

public protocol MarketProvider {
    func market(completion: @escaping (_: Result<Market, Error>) -> Void)
}
