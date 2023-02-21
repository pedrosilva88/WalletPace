//
//  ConfigaWallet.swift
//  WalletPace
//
//  Created by Pedro Silva on 16/02/2023.
//

import ComposableArchitecture

struct ConfigWallet: ReducerProtocol {
    struct State: Equatable {
        var wallet: Wallet?
        var liabilities: [Liability]?
        var incomes: [Income]?
        
        var currentWalletValue: String = ""
    }

    enum Action: Equatable {
        case walletUpdated(String)
        case newWalletAmount(value: Float)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.coredata) var coredata
    
    var body: some ReducerProtocol<State, Action> {
      Reduce { state, action in
          switch action {
          case .walletUpdated(let text):
              
              state.currentWalletValue = text
              guard let value = Float(text) else { return .none }
              coredata.createNewWalletActivity(amount: value)
              return .none
          default: return .none
          }
      }
    }
}

