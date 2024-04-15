//
//  WalletManager.swift
//  WalletPace
//
//  Created by Pedro Silva on 14/04/2024.
//

import Foundation
import Combine
import ComposableArchitecture
import Dependencies
import SwiftData

extension DependencyValues {
    var walletManager: WalletManager {
        get { self[WalletManager.self] }
        set { 
            print(newValue)
            self[WalletManager.self] = newValue }
    }
}

protocol WalletManagerProtocol {
    func syncWallet() -> EffectTask<Wallet>
    func incomes() -> EffectTask<[Income]>
    func liabilities() -> EffectTask<[Liability]>
    func addIncome(_ amount: Double) -> EffectTask<Bool>
    func addLiability(_ amount: Double) -> EffectTask<Bool>
}

struct WalletManager: WalletManagerProtocol {
    @Dependency(\.swiftData) var swiftData
    
    func syncWallet() -> EffectTask<Wallet> {
        let currentWallet: Wallet

        if let wallet = lastWallet {
            currentWallet = wallet
        } else {
            let newWallet = Wallet(amount: 0.0, dateCreated: .now)
            guard addWallet(newWallet) else { return .none}
            currentWallet = newWallet
        }
        
        let currentDate: Date = .now
        let difference = round(currentDate.timeIntervalSince(currentWallet.dateCreated))
        
        let newValue = amount + incrementPace * difference
                
        do {
            try swiftData.addWalletEvent(Wallet(amount: newValue, dateCreated: .now))
            let result = fetchLastWallet()
            switch result {
            case let .success(items):
                return EffectTask.send(items)
            case let .failure(error):
                return .none
            }
        } catch {
            return .none
        }
    }
    
    func incomes() -> EffectTask<[Income]> {
        let result = fetchIncomes()
        switch result {
        case let .success(items):
            return EffectTask.send(items)
        case let .failure(error):
            return .none
        }
    }
    
    func liabilities() -> EffectTask<[Liability]> {
        let result = fetchLiabilities()
        switch result {
        case let .success(items):
            return EffectTask.send(items)
        case let .failure(error):
            return .none
        }
    }
    
    func addIncome(_ amount: Double) -> EffectTask<Bool> {
        do {
            try swiftData.addIncome(Income(amount: amount, date: .now))
            return .none
        } catch {
            return .none
        }    }
    
    func addLiability(_ amount: Double) -> EffectTask<Bool> {
        do {
            try swiftData.addLiability(Liability(amount: amount, date: .now))
            return .none
        } catch {
            return .none
        }
    }
    
    private var incrementPace: Double {
        do {
            let incomes = try fetchIncomes().get()
            let liabilities = try fetchLiabilities().get()
            
            let sumIncome = incomes.reduce(0, { return $0 + $1.amount })
            let sumLiability = liabilities.reduce(0, { return $0 + $1.amount })
            // its being measured by month
            return ((sumIncome*12/365/24/60/60) - (sumLiability*12/365/24/60/60))
        } catch {
            return 0.0
        }
    }
    
    private var amount: Double {
        do {
            let wallet = try fetchLastWallet().get()
            return wallet.amount
        } catch {
            return 0.0
        }
    }
    
    private var lastWallet: Wallet? {
        do {
            let wallet = try fetchLastWallet().get()
            return wallet
        } catch {
            return nil
        }
    }
    
    private func fetchLastWallet() -> Result<Wallet, Error> {
        var descriptor = FetchDescriptor<Wallet>(sortBy: [SortDescriptor(\.dateCreated, order: .reverse)])
        descriptor.fetchLimit = 1
        do {
            let wallets = try swiftData.walletEvents(descriptor)
            guard let item = wallets.last else { return .failure(NSError()) }
            return .success(item)
        } catch {
            return .failure(NSError())
        }
    }
    
    private func fetchIncomes() -> Result<[Income], Error> {
        do {
            let incomes = try swiftData.incomes()
            return .success(incomes)
        } catch {
            return .failure(NSError())
        }
    }
    
    private func fetchLiabilities() -> Result<[Liability], Error> {
        do {
            let liabilities = try swiftData.liabilities()
            return .success(liabilities)
        } catch {
            return .failure(NSError())
        }
    }
    
    private func addWallet(_ wallet: Wallet) -> Bool {
        do {
            try swiftData.addWalletEvent(wallet)
            return true
        } catch {
            return false
        }
    }
}

extension WalletManager: DependencyKey {
    public static let liveValue = Self()
}

extension WalletManager: TestDependencyKey {
    public static var previewValue = Self.noop
    public static let testValue = Self(swiftData: Dependency(\.swiftData))
    static let noop = Self(swiftData: Dependency(\.swiftData))
}
