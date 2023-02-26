import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    public var coredata: CoreDataClient {
        get { self[CoreDataClient.self] }
        set { self[CoreDataClient.self] = newValue }
    }
}

extension CoreDataClient: TestDependencyKey {
    public static var previewValue: Self {
        let provider = Provider(persistenceContainer: .previewValue)
        
        return .init {
            provider.getWallet()
        } addWallet: {
            provider.setWallet(amount: $0)
        } incomes: {
            provider.getIncomes()
        } addIncome: {
            provider.createNewIncome(amount: $0)
        } removeIncome: {
            provider.removeIncome(item: $0)
        } liabilities: {
            provider.getLiabilities()
        } addLiability: {
            provider.createNewLiability(amount: $0)
        } removeLiability: {
            provider.removeLiability(item: $0)
        }
    }
    
    public static let testValue = Self()
}

extension CoreDataClient {
    public static var mock: Self {
        return Self()
    }
}
