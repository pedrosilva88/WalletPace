//
//  HomeState.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import Foundation
import ComposableArchitecture

struct Home: ReducerProtocol {
    struct State: Equatable {
        var wallet: Wallet?
        var liabilities: [Liability]?
        var incomes: [Income]?
        
        var amount: Float { wallet?.amount ?? 0 }
        
        var walletInAWeek: Float { amount + (incrementPace*60*60*24*7) }
        var walletInAMonth: Float { amount + (incrementPace*60*60*24*30) }
        var walletInAYear: Float { amount + (incrementPace*60*60*24*365) }
        var walletOnYearEnd: Float { 0 }
        
        var incrementInASecond: Float { incrementPace }
        var incrementInAMinute: Float { incrementPace*60 }
        var incrementInAHour: Float { incrementPace*60*60 }
        var incrementInADay: Float { incrementPace*60*60*24 }
        var incrementInAMonth: Float { incrementPace*60*60*24*30 }
        var incrementInAYear: Float { incrementPace*60*60*24*30*12 }
        
        var incrementPace: Float {
            let sumIncome = incomes?.reduce(0, { return $0 + $1.amount }) ?? 10000
            let sumLiability = liabilities?.reduce(0, { return $0 + $1.amount }) ?? 4000
            // its being measured by month
            return ((sumIncome*12/365/24/60/60) - (sumLiability*12/365/24/60/60))
        }
        
        var isConfigBeingPresented: Bool = false {
            didSet {
                print(self.isConfigBeingPresented)
            }
        }
        
        var configWallet: ConfigWallet.State
        
        init(configWallet: ConfigWallet.State = .init()) {
            self.configWallet = configWallet
        }
    }

    enum Action: Equatable {
        case task
        case updateWalletAmount
        case newWalletAmount
        case configWalletPresented(isPresented: Bool)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.coredata) var coredata
    
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
                guard !state.isConfigBeingPresented else { return .none }
                coredata.createNewWalletActivity(amount: (state.amount + state.incrementPace))
                return EffectTask(value: .newWalletAmount)
            case .newWalletAmount:
                state.wallet = coredata.fetchWallet()
                return .none
            case let .configWalletPresented(isPresented: isPresented):
                state.isConfigBeingPresented = isPresented
                return .none
            }
        }
    }
}
