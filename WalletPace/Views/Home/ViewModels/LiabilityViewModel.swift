//
//  LiabilityViewModel.swift
//  WalletPace
//
//  Created by Pedro Silva on 16/04/2024.
//

import Foundation

struct LiabilityViewModel: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String?
    let amount: Double?
}
