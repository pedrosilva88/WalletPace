//
//  HomeView.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import ComposableArchitecture
import SwiftUI
import CoreData

struct HomeView: View {
    let store: StoreOf<AppReducer>
    @State var isConfigWalletPresented: Bool = false
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    Text("\(viewStore.homeState.amount, specifier: "%.6f")")
                    HStack {
                        Text("\(viewStore.homeState.walletInAWeek, specifier: "%.2f")")
                        Text("\(viewStore.homeState.walletInAMonth, specifier: "%.2f")")
                        Text("\(viewStore.homeState.walletInAYear, specifier: "%.2f")")
                    }.padding(.top)
                    
                    HStack {
                        Text("\(viewStore.homeState.incrementInASecond, specifier: "%.2f")")
                        Text("\(viewStore.homeState.incrementInAMinute, specifier: "%.2f")")
                        Text("\(viewStore.homeState.incrementInAHour, specifier: "%.2f")")
                        Text("\(viewStore.homeState.incrementInADay, specifier: "%.2f")")
                        Text("\(viewStore.homeState.incrementInAMonth, specifier: "%.2f")")
                        Text("\(viewStore.homeState.incrementInAYear, specifier: "%.2f")")

                    }.padding(.top)
                }
                
                .navigationBarTitle("Wallet Pace")
                .navigationBarItems(trailing: Button("Config Wallet") { isConfigWalletPresented = true })
            }
            .sheet(isPresented: $isConfigWalletPresented,
                   content: { ConfigaWalletView(store:store.scope(state: \.configWalletState,
                                                                  action: AppReducer.Action.configWallet))})
            .task {
                await viewStore.send(.home(.task)).finish()
            }
//            .sheet(item: viewStore.binding(get: { $0.homeState.batatas }, send: AppReducer.Action.home(.updateWalletAmount)), content:  { _ in
//
//                EmptyView()
////                ConfigaWalletView(store:store.scope(state: \.configWalletState, action: AppReducer.Action.configWallet))
//            })

        }
        
        
    }
}


struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
      HomeView(
        store: Store(initialState: AppReducer.State(), reducer: AppReducer())
      )
  }
}
