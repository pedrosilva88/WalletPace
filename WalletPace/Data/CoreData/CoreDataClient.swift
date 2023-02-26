import ComposableArchitecture
import CoreData

public struct CoreDataClient {
    var wallet: () -> EffectTask<Wallet>
    var addWallet: (Double) -> EffectTask<Wallet>
    
    var incomes: () -> EffectTask<[Income]>
    var addIncome: (Double) -> EffectTask<[Income]>
    var removeIncome: (Income) -> EffectTask<[Income]>
    
    var liabilities: () -> EffectTask<[Liability]>
    var addLiability: (Double) -> EffectTask<[Liability]>
    var removeLiability: (Liability) -> EffectTask<[Liability]>
    
    public init(wallet: @escaping () -> EffectTask<Wallet> = { .none },
                addWallet: @escaping (Double) -> EffectTask<Wallet> = { _ in .none },
                incomes: @escaping () -> EffectTask<[Income]> = { .none },
                addIncome: @escaping (Double) -> EffectTask<[Income]> = { _ in .none },
                removeIncome: @escaping (Income) -> EffectTask<[Income]> = { _ in .none },
                liabilities: @escaping () -> EffectTask<[Liability]> = { .none },
                addLiability: @escaping (Double) -> EffectTask<[Liability]> = { _ in .none },
                removeLiability: @escaping (Liability) -> EffectTask<[Liability]> = { _ in .none }) {
        self.wallet = wallet
        self.addWallet = addWallet
        
        self.incomes = incomes
        self.addIncome = addIncome
        self.removeIncome = removeIncome
        
        self.liabilities = liabilities
        self.addLiability = addLiability
        self.removeLiability = removeLiability
    }
}

extension Liability {
    static var mock = Liability(amount: 120, date: .now)
    
    convenience init(amount: Double, date: Date) {
        let context = NSPersistentContainer.previewValue.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Liability", in: context)!
        
        self.init(entity: entity, insertInto: context)
        self.amount = amount
        self.dateCreated = date
        self.id = UUID()
    }
}


extension Income {
    static var mock = Income(amount: 120, date: .now)
    
    convenience init(amount: Double, date: Date) {
        let context = NSPersistentContainer.previewValue.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Income", in: context)!
        self.init(entity: entity, insertInto: context)
        self.amount = amount
        self.dateCreated = date
        self.id = UUID()
    }
}

extension Wallet {
    static var mock = Wallet(amount: 100, date: .now)
    
    convenience init(amount: Double, date: Date) {
        let context = NSPersistentContainer.previewValue.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Wallet", in: context)!
        self.init(entity: entity, insertInto: context)
        self.amount = amount
        self.dateCreated = date
        self.id = UUID()
    }
}
