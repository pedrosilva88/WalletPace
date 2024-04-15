//
//  WPDatabase.swift
//  WalletPace
//
//  Created by Pedro Silva on 13/04/2024.
//

import Foundation
import SwiftData
import Dependencies

typealias Wallet = WPDatabaseSchemaV1.Wallet
typealias Income = WPDatabaseSchemaV1.Income
typealias Liability = WPDatabaseSchemaV1.Liability

extension DependencyValues {
    var swiftData: WPDatabase {
        get { self[WPDatabase.self] }
        set { self[WPDatabase.self] = newValue }
    }
}

struct WPDatabase {
    var clearWalletEvents: @Sendable ([Wallet]) throws -> Void
    var walletEvents: @Sendable (FetchDescriptor<Wallet>) throws -> [Wallet]
    var incomes: @Sendable () throws -> [Income]
    var liabilities: @Sendable () throws -> [Liability]
    var addWalletEvent: @Sendable (Wallet) throws -> Void
    var addIncome: @Sendable (Income) throws -> Void
    var addLiability: @Sendable (Liability) throws -> Void
    var createWallet: @Sendable (Double, Date) throws -> Wallet?
    var createIncome: @Sendable (Double, Date) throws -> Income?
    var createLiability: @Sendable (Double, Date) throws -> Liability?
    
    enum WPDatabaseError: Error {
        case fetch
        case add
        case remove
        case unowned
    }
}


extension WPDatabase: DependencyKey {
    private static let clearWalletEvents: @Sendable ([Wallet]) throws -> Void = { wallets in
        do {
            @Dependency(\.databaseService.context) var context
            let wpContext = try context()
            wallets.forEach { wpContext.delete($0) }
        } catch {
            return
//                throw WPDatabaseError.remove
        }
    }
    
    private static let walletEvents: @Sendable (FetchDescriptor<Wallet>) throws -> [Wallet] = { descriptor in
        do {
            @Dependency(\.databaseService.context) var context
            let wpContext = try context()
            return try wpContext.fetch(descriptor)
        } catch {
            return []
        }
    }
    
    private static let incomes: @Sendable () throws -> [Income] = {
        do {
            @Dependency(\.databaseService.context) var context
            let wpContext = try context()
            
            return try wpContext.fetch(FetchDescriptor<Income>())
        } catch {
            return []
//                throw WPDatabaseError.fetch
        }
    }
    
    private static let liabilities: @Sendable () throws -> [Liability] = {
        do {
            @Dependency(\.databaseService.context) var context
            let wpContext = try context()
            
            return try wpContext.fetch(FetchDescriptor<Liability>())
        } catch {
            return []
//                throw WPDatabaseError.fetch
        }
    }
    
    private static let addWalletEvent: @Sendable (Wallet) throws -> Void = { item in
        do {
            @Dependency(\.databaseService.context) var context
            let wpContext = try context()
            wpContext.insert(item)
        } catch {
            return
//                throw WPDatabaseError.add
        }
    }
    
    private static let addIncome: @Sendable (Income) throws -> Void = { item in
        do {
            @Dependency(\.databaseService.context) var context
            let wpContext = try context()
            wpContext.insert(item)
        } catch {
            return
//                throw WPDatabaseError.add
        }
    }
    
    private static let addLiability: @Sendable (Liability) throws -> Void = { item in
        do {
            @Dependency(\.databaseService.context) var context
            let wpContext = try context()
            wpContext.insert(item)
        } catch {
            return
//                throw WPDatabaseError.add
        }
    }
    
    private static let createWallet: @Sendable (Double, Date) throws -> Wallet? = { Wallet(amount: $0, dateCreated: $1)}
    
    private static let createIncome: @Sendable (Double, Date) throws -> Income? = { Income(amount: $0, date: $1) }
    
    private static let createLiability: @Sendable (Double, Date) throws -> Liability? = { Liability(amount: $0, date: $1) }
    
    public static let liveValue = Self(
        clearWalletEvents: Self.clearWalletEvents,
        walletEvents: Self.walletEvents,
        incomes: Self.incomes,
        liabilities: Self.liabilities,
        addWalletEvent: Self.addWalletEvent,
        addIncome: Self.addIncome,
        addLiability: Self.addLiability,
        createWallet: Self.createWallet,
        createIncome: Self.createIncome,
        createLiability: Self.createLiability
    )
}

extension WPDatabase: TestDependencyKey {
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        clearWalletEvents: unimplemented("\(Self.self).clearWalletEvents"),
        walletEvents: unimplemented("\(Self.self).walletEvents"),
        incomes: unimplemented("\(Self.self).incomes"),
        liabilities: unimplemented("\(Self.self).liabilities"),
        addWalletEvent: unimplemented("\(Self.self).addWalletEvent"),
        addIncome: unimplemented("\(Self.self).addIncome"),
        addLiability: unimplemented("\(Self.self).addLiability"),
        createWallet: unimplemented("\(Self.self).createWallet"),
        createIncome: unimplemented("\(Self.self).createIncome"),
        createLiability: unimplemented("\(Self.self).createLiability")
    )
    
    static let noop = Self(
        clearWalletEvents: { _ in },
        walletEvents: { _ in [] },
        incomes: { [] },
        liabilities: { [] },
        addWalletEvent: { _ in },
        addIncome: { _ in },
        addLiability: { _ in },
        createWallet: { _, _ in nil },
        createIncome: { _, _ in nil },
        createLiability: { _, _ in nil }
    )
}
