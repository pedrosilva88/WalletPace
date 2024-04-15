//
//  Liability.swift
//  WalletPace
//
//  Created by Pedro Silva on 13/04/2024.
//

import Foundation
import SwiftData

extension WPDatabaseSchemaV1 {
    @Model
    class Liability: Identifiable {
        var id: UUID
        var amount: Double
        var dateCreated: Date
        var title: String?
        
        init(amount: Double, title: String? = nil, date: Date) {
            self.id = UUID()
            self.amount = amount
            self.title = title
            self.dateCreated = date
        }
    }
}
