//
//  CoreData.swift
//  WalletPace
//
//  Created by Pedro Silva on 13/02/2023.
//

import SwiftUI
import CoreData
import ComposableArchitecture


struct CoreDataReducer: ReducerProtocol {
    struct State: Equatable {}
    
    enum Action: Equatable {
        case task
        case fetchWallet
        case cleanWalletActivity
        case newWalletValue(value: Float)
        case walletResponse(wallet: Wallet)
    }
    
    var persistenceController = PersistenceController.shared
    @Environment(\.managedObjectContext) var context
    @Dependency(\.continuousClock) var clock
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .task:
            return
              .run { send in
                  for await _ in clock.timer(interval: .seconds(20)) {
                      await send(.cleanWalletActivity)
                  }}
        case .fetchWallet:
//            removeAllWalletActivity()
            let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
            do {
                let wallets = try persistenceController.context.fetch(fetchRequest)
                guard let item = wallets.last else { return .none }
                return EffectTask(value: .walletResponse(wallet: item))
            } catch {
                print("Unable to Fetch Wallets, (\(error))")
                return .none
            }
            
        case .cleanWalletActivity:
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

            return .none
        case .newWalletValue(let value):

            let item = Wallet(context: persistenceController.context)

            item.amount = value
            item.dateCreated = .now
            item.id = UUID()
            try? persistenceController.context.save()
            return EffectTask(value: .walletResponse(wallet: item))
        default: return .none
        }
    }
    
    private func removeAllWalletActivity() {
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        try? persistenceController.context.fetch(fetchRequest).forEach { persistenceController.context.delete($0) }
    }
}

extension Liability {
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
    convenience init(amount: Float, date: Date) {
        let context = PersistenceController.shared.context
        let entity = NSEntityDescription.entity(forEntityName: "Income", in: context)!
        self.init(entity: entity, insertInto: context)
        self.amount = amount
        self.dateCreated = date
        self.id = UUID()
    }
}
