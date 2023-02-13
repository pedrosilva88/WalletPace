//
//  HomeView.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    let store: StoreOf<Home>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            
            Text("\(viewStore.value)")
                .onAppear { viewStore.send(.onAppear) }
            //        NavigationView {
            //
            //            .navigationBarTitle("Todos")
            //            .navigationBarItems(trailing: Button("Add") {
            //            })
            //          }
                
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
