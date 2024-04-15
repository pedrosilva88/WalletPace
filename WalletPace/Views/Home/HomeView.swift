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
//                ScrollView {
                    VStack {
                        
                        Text("Your Balance").frame(alignment: .leading)
                        Text("\(viewStore.amount, specifier: "%.4f")")
                            .font(.title)
                            .padding(.init(top: 0, leading: 16, bottom: 16, trailing: 16))
                        
                        
                        
                    }
                    
//                    .frame(height: 0)
//                    .cornerRadius(20)
//                    .background(
//                        LinearGradient(gradient: Gradient(colors: [.init(hex: "266A61"), .init(hex: "266A61").opacity(0.48)]), startPoint: .leading, endPoint: .trailing)
//                    )
                    
//                    Box()
//                    Box()
//                    Spacer()
//                }
                .navigationBarTitle("Wallet Pace")
//                .ignoresSafeArea()
//                .background(
//                    LinearGradient(gradient: Gradient(colors: [.init(hex: "266A61"), .init(hex: "266A61").opacity(0.48)]), startPoint: .leading, endPoint: .trailing)
//                )
//                .background(
//                    LinearGradient(gradient: Gradient(colors: [.init(hex: "266A61"), .init(hex: "266A61").opacity(0.48)]), startPoint: .leading, endPoint: .trailing))
                .navigationBarItems(trailing: Button { viewStore.send(.configWalletPresented(isPresented: true)) } label: {
                    Image(systemName: "gear")
                }
                )
            }
            
            .sheet(isPresented: viewStore.binding(
                get: { $0.isConfigBeingPresented },
                send: { .configWalletPresented(isPresented: $0) }
            )) {
                ConfigaWalletView.init(store: store.scope(state: \.configWallet, action: Home.Action.configWallet))
            }.task {
                await viewStore.send(.task).finish()
            }
        }
    }
}

struct Box: View {
//    let size: CGSize
//    let factorHeight: CGFloat
//    let content: () -> Content
    
    
    //                                Box(size: metrics.size) {
    //                                    HStack(alignment: .center) {
    //                                        Text("\(viewStore.walletInAWeek, specifier: "%.2f")")
    //                                        Text("\(viewStore.walletInAMonth, specifier: "%.2f")")
    //                                        Text("\(viewStore.walletInAYear, specifier: "%.2f")")
    //                                    }
    //                                }
    //
    //                                Box(size: metrics.size) {
    //                                    HStack {
    //                                        Text("\(viewStore.incrementInASecond, specifier: "%.2f")")
    //                                        Text("\(viewStore.incrementInAMinute, specifier: "%.2f")")
    //                                        Text("\(viewStore.incrementInAHour, specifier: "%.2f")")
    //                                        Text("\(viewStore.incrementInADay, specifier: "%.2f")")
    //                                        Text("\(viewStore.incrementInAMonth, specifier: "%.2f")")
    //                                        Text("\(viewStore.incrementInAYear, specifier: "%.2f")")
    //                                    }
    //                                }
    init() { }
    
    var body: some View {
        
        VStack {
            Text("INCREASING SPEED")
            Divider()
            HStack {
                VStack {
                    Text("Second")
                    Text("0,35€")
                }
                VStack {
                    Text("Second")
                    Text("0,35€")
                }
                VStack {
                    Text("Second")
                    Text("0,35€")
                }
            }
            HStack {
                VStack {
                    Text("Second")
                    Text("0,35€")
                }
                VStack {
                    Text("Second")
                    Text("0,35€")
                }
                VStack {
                    Text("Second")
                    Text("0,35€")
                }
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: Home.State(), 
                              reducer: { Home().body },
                              withDependencies: {
            $0.swiftData = .previewValue
            $0.walletManager = .previewValue
        }))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
