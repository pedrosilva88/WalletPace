//
//  ConfigWallet.swift
//  WalletPace
//
//  Created by Pedro Silva on 16/02/2023.
//

import ComposableArchitecture
import SwiftUI

struct ConfigaWalletView: View {
    let store: StoreOf<ConfigWallet>
    @State private var favoriteColor = 0

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                Form {
                    Section {
                        TextField("Current wallet value", text: viewStore.binding(
                            get: \.currentWalletValue,
                            send: ConfigWallet.Action.walletUpdated
                        )).keyboardType(.numberPad)
                    }
                    Section {
                        Picker("", selection: $favoriteColor) {
                            Text("Incomes").tag(0)
                            Text("Liabilities").tag(1)
                        }.pickerStyle(.segmented)
                        
                        List {
                            if favoriteColor == 0 {
                                ForEach(viewStore.incomes ?? []) { item in
                                    Text("Test")
                                }
                            } else {
                                ForEach(viewStore.liabilities ?? []) { item in
                                    Text("Test")
                                }
                            }
                        }
                    }
                    Section {
                        Button(action: {}) {
                            Text("Save")
                        }
                    }
                }
                
                    

                .navigationBarTitle("Configure Wallet")
            }
        }
    }
}


struct ConfigaWalletView_Previews: PreviewProvider {
  static var previews: some View {
      ConfigaWalletView(
        store: Store(initialState: ConfigWallet.State(liabilities: [Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now),
                                                                           Liability(amount: 4000, date: .now)],
                                                             incomes: [Income(amount: 10000,
                                                                              date: .now)]), reducer: ConfigWallet())
      )
  }
}
