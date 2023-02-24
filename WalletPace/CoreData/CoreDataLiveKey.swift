//
//  CoreDataLiveKey.swift
//  WalletPace
//
//  Created by Pedro Silva on 20/02/2023.
//

import Combine
extension CoreData {
//  public static func live() -> Self {
//    return Self()
//  }
    
    static var live: Self {
        let walletTask = PassthroughSubject<Wallet?, Never>()
        let incomesTask = PassthroughSubject<[Income], Never>()
        let liabilitiesTask = PassthroughSubject<[Liability], Never>()
        
        return .init {
            walletTask
        } incomesTask: {
            incomesTask
        } liabilitiesTask: {
            liabilitiesTask
        }

    }
}
