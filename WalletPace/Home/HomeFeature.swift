//
//  HomeState.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import Foundation
import ComposableArchitecture

struct HomeReducer: ReducerProtocol {
    struct State: Equatable {
        var wallet: Wallet?
        
        var amount: Float { wallet?.amount ?? 0 }
        
        var walletInAWeek: Float { amount + (incrementPace*60*60*24*7) }
        var walletInAMonth: Float { amount + (incrementPace*60*60*24*7*30) }
        var walletInAYear: Float { amount + (incrementPace*60*60*24*365) }
        var walletOnYearEnd: Float { 0 }
        
        var incrementPace: Float = 0.0057
    }

    enum Action: Equatable {
        case task
        case updateWalletAmount
        case newWalletAmount(_ value: Float)
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerProtocol<State, Action> {
      Reduce { state, action in
          switch action {
          case .task:
              return
                .run { send in
                    
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.updateWalletAmount)
                    }}
          case .updateWalletAmount:
              return EffectTask(value: .newWalletAmount((state.amount + state.incrementPace)))
          case .newWalletAmount:
              return .none
          }
      }
    }
}
