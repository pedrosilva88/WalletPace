//
//  WalletMigrations.swift
//  WalletPace
//
//  Created by Pedro Silva on 13/04/2024.
//

import Foundation
import SwiftData
import Dependencies

enum WPDatabaseSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [Wallet.self, Income.self, Liability.self]
    }
}

enum WPDatabaseMigrationPlan: SchemaMigrationPlan {
    static var stages: [MigrationStage] {
        []
//        [migrateV1toV2]
    }
    
    static var schemas: [any VersionedSchema.Type] {
        [WPDatabaseSchemaV1.self]
        //[WalletSchemaV1.self, WalletSchemaV2.self]
    }
    
    
//    static let migrateV1toV2 = MigrationStage.lightweight(
//        fromVersion: WalletSchemaV1.self,
//        toVersion: WalletSchemaV2.self
//    )
}



// Schema Migration V2
/*
 enum WalletSchemaV2: VersionedSchema {
     static var versionIdentifier = Schema.Version(2, 0, 0)
 
     static var models: [any PersistentModel.Type] {
         [Wallet.self]
     }
 
     @Model
     class Wallet: Identifiable {
         var id: UUID
         var title: String
         var cast: [String]
         var favorite: Bool = false
 
         init(title: String, cast: [String], favorite: Bool = false) {
             self.id = UUID()
             self.title = title
             self.cast = cast
             self.favorite = favorite
         }
     }
 }
 */
