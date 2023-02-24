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
        
        var currentWalletValue: String = "" //{ String(self.wallet?.amount ?? 0) }
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
//        case newWalletAmount(value: Float)
        case tabSelected(State.Tab)
        case didTapToShowAddItemView
        case didTapToAddItem
        case didDismissAddItemView(Bool)
        case didSwipeToRemoveIncome(IndexSet)
        case didSwipeToRemoveLiability(IndexSet)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.coredata) var coredata
    
    var body: some ReducerProtocol<State, Action> {
      Reduce { state, action in
          switch action {
          case .onAppear:
//              state.wallet = coredata.fetchWallet()
//              state.incomes = coredata.fetchIncomes()
//              state.liabilities = coredata.fetchLiabilities()
              guard let value = state.wallet?.amount else { return .none }
              state.currentWalletValue = String(value)
              return .none
              
          case .walletUpdated(let text):
              state.currentWalletValue = text
              guard let value = Float(text) else { return .none }
              coredata.createNewWalletActivity(amount: value)
//              state.wallet = coredata.fetchWallet()
              return .none
              
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
              guard let amount = Float(state.currentAmountValue) else { return .none }
              switch state.tabSelected {
              case .incomes:
                  coredata.createNewIncome(amount: amount)
//                  state.incomes = coredata.fetchIncomes()
              case .liabilities:
                  coredata.createNewLiability(amount: amount)
//                  state.liabilities = coredata.fetchLiabilities()
              }
              return EffectTask.send(.didDismissAddItemView(false))
              
              
          case .didSwipeToRemoveIncome(let offsets):
              offsets.forEach { index in
                  let income = state.incomes[index]
                  coredata.removeIncome(income)
              }
//              state.incomes = coredata.fetchIncomes()
              return .none
          case .didSwipeToRemoveLiability(let offsets):
              offsets.forEach { index in
                  let liability = state.liabilities[index]
                  coredata.removeLiablity(liability)
              }
//              state.liabilities = coredata.fetchLiabilities()
              return .none

//          default: return .none
          }
      }
    }
}

