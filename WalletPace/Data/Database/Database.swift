//
//  Database.swift
//  WalletPace
//
//  Created by Pedro Silva on 13/04/2024.
//

import Foundation
import SwiftData
import Dependencies

private let DATABASE_NAME = "WALLEPACE_DB.sqlite"

extension DependencyValues {
    var databaseService: Database {
        get { self[Database.self] }
        set { self[Database.self] = newValue }
    }
}

fileprivate let appContext: ModelContext = {
    do {
        let url = URL.applicationSupportDirectory.appending(path: DATABASE_NAME)
        let config = ModelConfiguration(url: url)
        
        let container = try ModelContainer(for: Wallet.self, Income.self, Liability.self, migrationPlan: WPDatabaseMigrationPlan.self, configurations: config)
        return ModelContext(container)
    } catch {
        fatalError("Failed to create container.")
    }
}()

struct Database {
    var context: () throws -> ModelContext
}

extension Database: DependencyKey {
    public static let liveValue = Self(
        context: { appContext }
    )
}

extension Database: TestDependencyKey {
    public static var previewValue = Self.noop
    
    public static let testValue = Self(
        context: unimplemented("\(Self.self).context")
    )
    
    static let noop = Self(
        context: unimplemented("\(Self.self).context")
    )
}
