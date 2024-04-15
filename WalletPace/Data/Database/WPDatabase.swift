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
    
    enum WPDatabaseError: Error {
        case fetch
        case add
        case remove
        case unowned
    }
}


extension WPDatabase: DependencyKey {
    public static let liveValue = Self(
        clearWalletEvents: { wallets in
            do {
                @Dependency(\.databaseService.context) var context
                let wpContext = try context()
                wallets.forEach { wpContext.delete($0) }
            } catch {
                return
//                throw WPDatabaseError.remove
            }
        },
        walletEvents: { descriptor in
            do {
                @Dependency(\.databaseService.context) var context
                let wpContext = try context()
                return try wpContext.fetch(descriptor)
            } catch {
                return []
            }
        },
        incomes: {
            do {
                @Dependency(\.databaseService.context) var context
                let wpContext = try context()
                
                return try wpContext.fetch(FetchDescriptor<Income>())
            } catch {
                return []
//                throw WPDatabaseError.fetch
            }
        },
        liabilities: {
            do {
                @Dependency(\.databaseService.context) var context
                let wpContext = try context()
                
                return try wpContext.fetch(FetchDescriptor<Liability>())
            } catch {
                return []
//                throw WPDatabaseError.fetch
            }
        },
        addWalletEvent: { item in
            do {
                @Dependency(\.databaseService.context) var context
                let wpContext = try context()
                wpContext.insert(item)
            } catch {
                return
//                throw WPDatabaseError.add
            }
        },
        addIncome: { item in
            do {
                @Dependency(\.databaseService.context) var context
                let wpContext = try context()
                wpContext.insert(item)
            } catch {
                return
//                throw WPDatabaseError.add
            }
        },
        addLiability: { item in
            do {
                @Dependency(\.databaseService.context) var context
                let wpContext = try context()
                wpContext.insert(item)
            } catch {
                return
//                throw WPDatabaseError.add
            }
        }
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
        addLiability: unimplemented("\(Self.self).addLiability")
    )
    
    static let noop = Self(
        clearWalletEvents: { _ in },
        walletEvents: { _ in [] },
        incomes: { [] },
        liabilities: { [] },
        addWalletEvent: { _ in },
        addIncome: { _ in },
        addLiability: { _ in }
    )
}
