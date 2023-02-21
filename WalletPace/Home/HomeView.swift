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
    let store: StoreOf<Home>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    Text("\(viewStore.amount, specifier: "%.4f")")
                    HStack {
                        Text("\(viewStore.walletInAWeek, specifier: "%.2f")")
                        Text("\(viewStore.walletInAMonth, specifier: "%.2f")")
                        Text("\(viewStore.walletInAYear, specifier: "%.2f")")
                    }.padding(.top)
                    
                    HStack {
                        Text("\(viewStore.incrementInASecond, specifier: "%.2f")")
                        Text("\(viewStore.incrementInAMinute, specifier: "%.2f")")
                        Text("\(viewStore.incrementInAHour, specifier: "%.2f")")
                        Text("\(viewStore.incrementInADay, specifier: "%.2f")")
                        Text("\(viewStore.incrementInAMonth, specifier: "%.2f")")
                        Text("\(viewStore.incrementInAYear, specifier: "%.2f")")

                    }.padding(.top)
                }
                
                .navigationBarTitle("Wallet Pace")
                .navigationBarItems(trailing: Button("Config Wallet") { viewStore.send(.configWalletPresented(isPresented: true)) })
            }
            .sheet(isPresented: viewStore.binding(
                get: { $0.isConfigBeingPresented },
                send: { .configWalletPresented(isPresented: $0) }
            )) { ConfigaWalletView.init(store: store.scope(state: \.configWallet, action: Home.Action.configWallet))
            }
            .task {
                await viewStore.send(.task).finish()
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
      HomeView(
        store: Store(initialState: Home.State(), reducer: Home())
      )
  }
}
