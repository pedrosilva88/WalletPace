//
//  ConfigaWallet.swift
//  WalletPace
//
//  Created by Pedro Silva on 16/02/2023.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ConfigWallet {
    @ObservableState
    struct State: Equatable {
        var wallet: WalletViewModel?
        var incomes: [IncomeViewModel] = []
        var liabilities: [LiabilityViewModel] = []
        
        var currentWalletValue: String { "\(round(100 * (wallet?.amount ?? 0.0)) / 100)" }
        var currentAmountValue: String = ""
        var tabSelected: Tab = .incomes
        var isPresentingAddItemView: Bool = false
        
        enum Tab: Int {
            case incomes
            case liabilities
            
            var title: String {
                switch self {
                case .incomes: return "Incomes"
                case .liabilities: return "Liablities"
                }
            }
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case walletUpdated(String)
        case amountUpdated(String)
        
        case walletResponse(Wallet)
        case syncWallet
        case syncIncomes
        case syncLiabilities
        case incomes([Income])
        case liabilities([Liability])
        case tabSelected(State.Tab)
        case didTapToShowAddItemView
        case didTapToAddItem
        case didDismissAddItemView(Bool)
        case didSwipeToRemoveIncome(IndexSet)
        case didSwipeToRemoveLiability(IndexSet)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.walletManager) var walletManager
    
    struct ConfigWalletCancelId: Hashable {}
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(
                    walletManager.syncWallet()
                        .map(ConfigWallet.Action.walletResponse)
                        .cancellable(id: ConfigWalletCancelId()),
                    
                    walletManager.liabilities()
                        .map(ConfigWallet.Action.liabilities)
                        .cancellable(id: ConfigWalletCancelId()),
                    
                    walletManager.incomes()
                        .map(ConfigWallet.Action.incomes)
                        .cancellable(id: ConfigWalletCancelId())
                )
            case .walletUpdated(let text):
                guard let value = Double(text) else { return .none }
                walletManager.addWallet(value)
                return .send(.syncWallet)
                
            case .syncWallet:
                return walletManager.syncWallet()
                    .map(ConfigWallet.Action.walletResponse)
                    .cancellable(id: ConfigWalletCancelId())

            case .amountUpdated(let text):
                state.currentAmountValue = text
                return .none
                
            case .tabSelected(let tab):
                state.tabSelected = tab
                return .none
                
            case .didTapToShowAddItemView:
                state.isPresentingAddItemView = true
                return .none
                
            case .didDismissAddItemView(let isPresented):
                state.isPresentingAddItemView = isPresented
                return .none
                
            case .didTapToAddItem:
                guard let amount = Double(state.currentAmountValue) else { return .none }
                switch state.tabSelected {
                case .incomes:
                    walletManager.addIncome(amount)
                    return .send(.syncIncomes)
                    
                case .liabilities:
                    walletManager.addLiability(amount)
                    return .send(.syncLiabilities)
                }
            case .didSwipeToRemoveIncome(let offsets):
                //              offsets.forEach { index in
                //                  let income = state.incomes[index]
                ////                  coredata.removeIncome(income).sink(receiveValue: { income in
                ////                      state.incomes = income
                ////                  }).cancel()
                //              }
                //              state.incomes = coredata.fetchIncomes()
                return .none
            case .didSwipeToRemoveLiability(let offsets):
                //              offsets.forEach { index in
                //                  let liability = state.liabilities[index]
                //
                //                  return coredata.removeLiability(liability)
                //                      .map(ConfigWallet.Action.liabilitiesResponse)
                //                      .cancellable(id: ConfigWalletCancelId())
                //              }
                //              state.liabilities = coredata.fetchLiabilities()
                return .none
                
            case .walletResponse(let wallet):
                state.wallet = WalletViewModel(amount: wallet.amount ?? 0)
            case .syncIncomes:
                return walletManager.incomes()
                    .map(ConfigWallet.Action.incomes)
                    .cancellable(id: ConfigWalletCancelId())
            case .incomes(let items):
                state.incomes = items.compactMap({ IncomeViewModel(title: $0.title, amount: $0.amount) })
            case .syncLiabilities:
                return walletManager.liabilities()
                    .map(ConfigWallet.Action.liabilities)
                    .cancellable(id: ConfigWalletCancelId())
            case .liabilities(let items):
                state.liabilities = items.compactMap({ LiabilityViewModel(title: $0.title, amount: $0.amount) })
            }
            
            return .none
        }
    }
}

