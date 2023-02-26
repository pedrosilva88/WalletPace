//
//  CoreDataLiveKey.swift
//  WalletPace
//
//  Created by Pedro Silva on 20/02/2023.
//

import Combine
import ComposableArchitecture

extension CoreDataClient {    
    static var live: Self {
        let provider = Provider()
        return .init {
            provider.getWallet()
        } addWallet: {
            provider.setWallet(amount: $0)
        } incomes: {
            provider.getIncomes()
        } addIncome: {
            provider.createNewIncome(amount: $0)
        } removeIncome: {
            provider.removeIncome(item: $0)
        } liabilities: {
            provider.getLiabilities()
        } addLiability: {
            provider.createNewLiability(amount: $0)
        } removeLiability: {
            provider.removeLiability(item: $0)
        }
    }
}
