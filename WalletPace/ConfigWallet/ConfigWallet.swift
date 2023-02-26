//
//  ConfigaWallet.swift
//  WalletPace
//
//  Created by Pedro Silva on 16/02/2023.
//

import ComposableArchitecture
import Foundation

struct ConfigWallet: ReducerProtocol {
    struct State: Equatable {
        var wallet: Wallet?
        var incomes: [Income] = []
        var liabilities: [Liability] = []
        
        
        var currentWalletValue: String = ""
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
//        case newWalletAmount(value: Double)
        
        case walletResponse(Wallet)
        case incomesResponse([Income])
        case liabilitiesResponse([Liability])
        case tabSelected(State.Tab)
        case didTapToShowAddItemView
        case didTapToAddItem
        case didDismissAddItemView(Bool)
        case didSwipeToRemoveIncome(IndexSet)
        case didSwipeToRemoveLiability(IndexSet)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.coredata) var coredata
    
    struct ConfigWalletCancelId: Hashable {}
        
    var body: some ReducerProtocol<State, Action> {
      Reduce { state, action in
          switch action {
          case .onAppear:
              guard let value = state.wallet?.amount else { return .none }
              state.currentWalletValue = String(value)
              return .none
              
          case .walletUpdated(let text):
              state.currentWalletValue = text
              guard let value = Double(text) else { return .none }
              return coredata.addWallet(value)
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
                  return coredata.addIncome(amount)
                      .map(ConfigWallet.Action.incomesResponse)
                      .cancellable(id: ConfigWalletCancelId())
                  
              case .liabilities:
                  return coredata.addLiability(amount)
                      .map(ConfigWallet.Action.liabilitiesResponse)
                      .cancellable(id: ConfigWalletCancelId())
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
              state.wallet = wallet
          case .incomesResponse(let incomes):
              state.incomes = incomes
          case .liabilitiesResponse(let liabilities):
              state.liabilities = liabilities
          }
          
          return .none
      }
    }
}

