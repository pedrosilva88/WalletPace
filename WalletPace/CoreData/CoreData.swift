//
//  CoreData.swift
//  WalletPace
//
//  Created by Pedro Silva on 13/02/2023.
//

import SwiftUI
import CoreData
import Combine
import ComposableArchitecture

public struct CoreData {    
    var walletTask: () -> PassthroughSubject<Wallet?, Never>
    var incomesTask: () -> PassthroughSubject<[Income], Never>
    var liabilitiesTask: () -> PassthroughSubject<[Liability], Never>
    
    var persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) var context
    @Dependency(\.continuousClock) var clock
    
    public init(walletTask: @escaping () -> PassthroughSubject<Wallet?, Never> = { PassthroughSubject() },
                incomesTask: @escaping () -> PassthroughSubject<[Income], Never> = { PassthroughSubject() },
                liabilitiesTask: @escaping () -> PassthroughSubject<[Liability], Never> = { PassthroughSubject() }) {
        self.walletTask = walletTask
        self.incomesTask = incomesTask
        self.liabilitiesTask = liabilitiesTask
    }
    
    func clearWalletActivity() {
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        do {
            let wallets = try persistenceController.context.fetch(fetchRequest)
            print(wallets.count)
            if wallets.count > 100 {
                wallets[0...(wallets.count-10)].forEach { persistenceController.context.delete($0) }
            }
        } catch {
            print("Unable to Remove Wallets, (\(error))")
        }
    }
    
    func loadWallet() {
        //            removeAllWalletActivity()

        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        do {
            let wallets = try persistenceController.context.fetch(fetchRequest)
            guard let item = wallets.last else { return }
            walletTask().send(item)
        } catch {
            print("Unable to Fetch Wallets, (\(error))")
        }
    }
    
    func loadIncomes() {
        let fetchRequest: NSFetchRequest<Income> = Income.fetchRequest()
        do {
            let incomes = try persistenceController.context.fetch(fetchRequest)
            incomesTask().send(incomes)
        } catch {
            print("Unable to Fetch Incomes, (\(error))")
        }
    }
    
    func loadLiabilities() {
        let fetchRequest: NSFetchRequest<Liability> = Liability.fetchRequest()
        do {
            let liabilities = try persistenceController.context.fetch(fetchRequest)
            liabilitiesTask().send(liabilities)
        } catch {
            print("Unable to Fetch Liabilities, (\(error))")
        }
    }
    
    func createNewWalletActivity(amount: Float) {
        let item = Wallet(context: persistenceController.context)

        item.amount = amount
        item.dateCreated = .now
        item.id = UUID()
        try? persistenceController.context.save()
        
        walletTask().send(item)
    }
    
    func createNewIncome(amount: Float) {
        let item = Income(context: persistenceController.context)

        item.amount = amount
        item.dateCreated = .now
        item.id = UUID()
        try? persistenceController.context.save()
        loadIncomes()
    }
    
    func createNewLiability(amount: Float) {
        let item = Liability(context: persistenceController.context)

        item.amount = amount
        item.dateCreated = .now
        item.id = UUID()
        try? persistenceController.context.save()
        loadLiabilities()
    }
    
    func removeIncome(_ item: Income) {
        persistenceController.context.delete(item)
        loadIncomes()
    }
    
    func removeLiablity(_ item: Liability) {
        persistenceController.context.delete(item)
        loadLiabilities()
    }
        
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
