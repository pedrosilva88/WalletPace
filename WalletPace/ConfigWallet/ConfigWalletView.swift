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
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                ZStack {
                    Form {
                        
                        Section("Reset your wallet") {
                            TextField("", text: viewStore.binding(
                                get: \.currentWalletValue,
                                send: ConfigWallet.Action.walletUpdated
                            )).keyboardType(.numberPad)
                        }
                        
                        Picker("", selection: viewStore.binding(
                            get: \.tabSelected,
                            send: ConfigWallet.Action.tabSelected)
                        ) {
                            Text(ConfigWallet.State.Tab.incomes.title).tag(ConfigWallet.State.Tab.incomes)
                            Text(ConfigWallet.State.Tab.liabilities.title).tag(ConfigWallet.State.Tab.liabilities)
                        }.pickerStyle(.segmented)
                        
                        Section {
                            
                            
                            List {
                                
                                switch viewStore.state.tabSelected {
                                case .incomes:
                                    ForEach(viewStore.incomes) { item in
                                        Text("Income: \(item.amount, specifier: "%.2f")€")
                                    }
                                    .onDelete { offsets in
                                        viewStore.send(ConfigWallet.Action.didSwipeToRemoveIncome(offsets))
                                    }
                                case .liabilities:
                                    ForEach(viewStore.liabilities) { item in
                                        Text("Liability: \(item.amount, specifier: "%.2f")€")
                                    }
                                    .onDelete { offsets in
                                        viewStore.send(ConfigWallet.Action.didSwipeToRemoveLiability(offsets))
                                    }
                                }
                            }
                        }
                    }
                    DoubleingButton(action: {
                        viewStore.send(.didTapToShowAddItemView)
                    }, icon: "plus")
                    
                }.sheet(isPresented: viewStore.binding(get: \.isPresentingAddItemView, send: ConfigWallet.Action.didDismissAddItemView), content: {
                    HStack {
                        HStack {
                            TextField("Amount:", text: viewStore.binding(
                                get: \.currentAmountValue,
                                send: ConfigWallet.Action.amountUpdated
                            )).keyboardType(.numberPad)
                            
                            
                            Button("✅") {viewStore.send(.didTapToAddItem)}
                        }.padding(.horizontal)
                            .presentationDetents([.fraction(0.30)])
                    }
                })
                .navigationBarTitle("Configure Wallet")
            }
            .onAppear() { viewStore.send(.onAppear) }
        }
    }
}

struct DoubleingButton: View {
    let action: () -> Void
    let icon: String
    let color: Color = .green
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: icon)
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                }
                .frame(width: 60, height: 60)
                .background(color)
                .cornerRadius(30)
                .shadow(radius: 10)
                .offset(x: -40, y: -20)
            }
        }
    }
}


struct ConfigaWalletView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigaWalletView(
            store: Store(initialState: ConfigWallet.State(incomes: [Income(amount: 10000, date: .now)],
                                                          liabilities: [Liability(amount: 4000, date: .now),
                                                                        Liability(amount: 4000, date: .now),
                                                                        Liability(amount: 4000, date: .now),
                                                                        Liability(amount: 4000, date: .now),
                                                                        Liability(amount: 4000, date: .now)]),
                         reducer: ConfigWallet().dependency(\.coredata, .previewValue))
        )
    }
}
