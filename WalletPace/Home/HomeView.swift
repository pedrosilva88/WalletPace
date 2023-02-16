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

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                VStack {
                    Text("\(viewStore.homeState.amount, specifier: "%.2f")")
                    HStack {
                        Text("\(viewStore.homeState.walletInAWeek, specifier: "%.2f")")
                        Text("\(viewStore.homeState.walletInAMonth, specifier: "%.2f")")
                        Text("\(viewStore.homeState.walletInAYear, specifier: "%.2f")")
                    }
                }
                
                .navigationBarTitle("Wallet Pace")
                .navigationBarItems(trailing: Button("Reset Wallet") {
                    
                })
            }
            .sheet(isPresented: .constant(true), content: {
                EmptyView()
            })
            .task {
                await viewStore.send(.home(.task)).finish()
            }
        }
        
    }
    
//    private func presentSheet() -> any View {
//        return
//    }
}


struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
      HomeView(
        store: Store(initialState: AppReducer.State(), reducer: AppReducer())
      )
  }
}
