//
//  WalletPaceApp.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct AppReducer: ReducerProtocol {
    struct State: Equatable {
        var wallet: Wallet?
        var liabilities: [Liability]?
        var incomes: [Income]?
    }
    enum Action {
        case coredata(CoreDataReducer.Action)
        case home(HomeReducer.Action)
        case configWallet(ConfigWalletReducer.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.coreDataState, action: /Action.coredata) {
            CoreDataReducer()
        }
        Scope(state: \.homeState, action: /Action.home) {
            HomeReducer()
        }
        
        Scope(state: \.configWalletState, action: /Action.configWallet) {
            ConfigWalletReducer()
        }
        
        Reduce { state, action in
            switch action {
            
            case .coredata(CoreDataReducer.Action.walletResponse(let wallet)):
                state.wallet = wallet
                return .none
            case .home(HomeReducer.Action.task):
                return EffectTask.merge(EffectTask(value: Action.coredata(.task)), EffectTask(value: Action.coredata(.fetchWallet)))
            case .home(HomeReducer.Action.newWalletAmount(let value)):
                return EffectTask(value: Action.coredata(CoreDataReducer.Action.newWalletValue(value: value)))
            case .configWallet(ConfigWalletReducer.Action.newWalletAmount(let value)):
                return EffectTask(value: Action.coredata(CoreDataReducer.Action.newWalletValue(value: value)))
            default: return .none
            }
        
        }
    }
}

extension AppReducer.State {
    var coreDataState: CoreDataReducer.State { get{ return CoreDataReducer.State() } set{} }
}

extension AppReducer.State {
    var homeState: HomeReducer.State {
        get {
            return HomeReducer.State(wallet: self.wallet)
        }
        set {
            self.wallet = newValue.wallet
        }
    }
}

extension AppReducer.State {
    var configWalletState: ConfigWalletReducer.State {
        get {
            return ConfigWalletReducer.State(wallet: self.wallet, liabilities: self.liabilities, incomes: self.incomes)
        }
        set {
            self.wallet = newValue.wallet
            self.liabilities = newValue.liabilities
            self.incomes = newValue.incomes
        }
    }
}

@main
struct WalletPaceApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(store: Store(initialState: AppReducer.State(), reducer: AppReducer()))
        }
    }
}
