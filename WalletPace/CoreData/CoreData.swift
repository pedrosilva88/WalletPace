//
//  CoreData.swift
//  WalletPace
//
//  Created by Pedro Silva on 13/02/2023.
//

import SwiftUI
import CoreData
import ComposableArchitecture

public struct CoreData {
    var persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) var context
    @Dependency(\.continuousClock) var clock

    func clearWalletActivity() {
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        do {
            let wallets = try persistenceController.context.fetch(fetchRequest)
            print(wallets.count)
            if wallets.count > 100 {
                wallets[0...(wallets.count-10)].forEach { persistenceController.context.delete($0) }
            }
        } catch {
            print("Unable to Fetch Wallets, (\(error))")
        }
    }
    
    func fetchWallet() -> Wallet? {
        //            removeAllWalletActivity()

        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        do {
            let wallets = try persistenceController.context.fetch(fetchRequest)
            guard let item = wallets.last else { return .none }
            return item
        } catch {
            print("Unable to Fetch Wallets, (\(error))")
            return nil
        }
    }
    
    func fetchIncomes() -> [Income] { return [.mock] }
    
    func fetchLiabilities() -> [Liability] { return [.mock] }
    
    func createNewWalletActivity(amount: Float) {
        let item = Wallet(context: persistenceController.context)

        item.amount = amount
        item.dateCreated = .now
        item.id = UUID()
        try? persistenceController.context.save()
    }
    
    func createNewIncome(amount: Float) {}
    
    func createNewLiability(amount: Float) {}
    
    func removeIncome(_ item: Income) {}
    
    func removeLiablity(_ item: Liability) {}
        
    private func removeAllWalletActivity() {
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        try? persistenceController.context.fetch(fetchRequest).forEach { persistenceController.context.delete($0) }
    }
}

extension Liability {
    static var mock = Liability(amount: 120, date: .now)
    
    convenience init(amount: Float, date: Date) {
        let context = PersistenceController.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "Liability", in: context)!
        
        self.init(entity: entity, insertInto: context)
        self.amount = amount
        self.dateCreated = date
        self.id = UUID()
    }
}


extension Income {
    static var mock = Income(amount: 120, date: .now)
    
    convenience init(amount: Float, date: Date) {
        let context = PersistenceController.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "Income", in: context)!
        self.init(entity: entity, insertInto: context)
        self.amount = amount
        self.dateCreated = date
        self.id = UUID()
    }
}

extension Wallet {
    static var mock = Wallet(amount: 100, date: .now)
    
    convenience init(amount: Float, date: Date) {
        let context = PersistenceController.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "Wallet", in: context)!
        self.init(entity: entity, insertInto: context)
        self.amount = amount
        self.dateCreated = date
        self.id = UUID()
    }
}
