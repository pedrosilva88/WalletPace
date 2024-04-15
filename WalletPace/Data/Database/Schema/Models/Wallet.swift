//
//  Wallet.swift
//  WalletPace
//
//  Created by Pedro Silva on 13/04/2024.
//

import Foundation
import SwiftData

extension WPDatabaseSchemaV1 {
    @Model
    class Wallet: Identifiable {
        var id: UUID
        var amount: Double
        var dateCreated: Date
        
        init(amount: Double, dateCreated: Date) {
            self.id = UUID()
            self.amount = amount
            self.dateCreated = dateCreated
        }
    }
}
