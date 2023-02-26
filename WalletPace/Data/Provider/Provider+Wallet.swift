import ComposableArchitecture
import CoreData
import Foundation

extension Provider {
    func clearWalletActivity() {
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        do {
            let wallets = try persistenceContainer.viewContext.fetch(fetchRequest)
            print(wallets.count)
            if wallets.count > 100 {
                wallets[0...(wallets.count-10)].forEach { persistenceContainer.viewContext.delete($0) }
            }
        } catch {
            print("Unable to Remove Wallets, (\(error))")
        }
    }

    func getWallet() -> EffectTask<Wallet> {
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        do {
            let wallets = try persistenceContainer.viewContext.fetch(fetchRequest)
            guard let item = wallets.last else { return .none }
            return EffectTask.send(item)
        } catch {
            print("Unable to Fetch Wallets, (\(error))")
            return .none
        }
        
    }
    
    func getIncomes() -> EffectTask<[Income]> {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        do {
            let incomes = try persistenceContainer.viewContext.fetch(fetchRequest)
            return EffectTask.send(incomes)
        } catch {
            print("Unable to Fetch Incomes, (\(error))")
            return .none
        }
    }

    func getLiabilities() -> EffectTask<[Liability]> {
        let fetchRequest: NSFetchRequest<Liability> = Liability.fetchRequest()
        do {
            let liabilities = try persistenceContainer.viewContext.fetch(fetchRequest)
            return EffectTask.send(liabilities)
        } catch {
            print("Unable to Fetch Liabilities, (\(error))")
            return .none
        }
    }
    
    func setWallet(amount: Double) -> EffectTask<Wallet> {
        let item = Wallet(context: persistenceContainer.viewContext)

        item.amount = amount
        item.dateCreated = .now
        item.id = UUID()
        persistenceContainer.saveContext()
        
        return EffectTask.send(item)
    }
    
    func createNewIncome(amount: Double) -> EffectTask<[Income]> {
        let item = Income(context: persistenceContainer.viewContext)

        item.amount = amount
        item.dateCreated = .now
        item.id = UUID()
        persistenceContainer.saveContext()
        return getIncomes()
    }
    
    func createNewLiability(amount: Double) -> EffectTask<[Liability]> {
        let item = Liability(context: persistenceContainer.viewContext)

        item.amount = amount
        item.dateCreated = .now
        item.id = UUID()
        persistenceContainer.saveContext()
        return getLiabilities()
    }
    
    func removeIncome(item: Income) -> EffectTask<[Income]> {
        persistenceContainer.viewContext.delete(item)
        return getIncomes()
    }
    
    func removeLiability(item: Liability) -> EffectTask<[Liability]> {
        persistenceContainer.viewContext.delete(item)
        return getLiabilities()
    }

    private func removeAllWalletActivity() {
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        try? persistenceContainer.viewContext.fetch(fetchRequest).forEach {
            persistenceContainer.viewContext.delete($0)
        }
    }
}
