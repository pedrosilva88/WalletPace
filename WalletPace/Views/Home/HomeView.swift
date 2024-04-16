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
            
            GeometryReader { geometry in
                
                ScrollView {
                    VStack {
                        ZStack {
                            
                            VStack {
                                Spacer()
                                Text("Your Balance")
                                    .font(.caption)
                                    .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 0))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(viewStore.amount, specifier: "%.2f €")")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(.init(top: 1, leading: 16, bottom: 32, trailing: 16))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(width: geometry.size.width, height: geometry.size.height*0.3)
                            .background(
                                RoundedRectangle(cornerRadius: 40).fill(
                                    LinearGradient(gradient: Gradient(colors: [.init(hex: "266A61"), .init(hex: "266A61").opacity(0.48)]), startPoint: .leading, endPoint: .trailing))
                            )
                            
                            VStack {
                                HStack {
                                    Text("WalletPace")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .padding(.init(top: 64, leading: 0, bottom: 0, trailing: 0))
                                    
                                    Button { viewStore.send(.configWalletPresented(isPresented: true)) } label: {
                                        Image(systemName: "gear")
                                            .foregroundColor(.black)
                                    }                                        
                                    .padding(.init(top: 64, leading: 0, bottom: 0, trailing: 0))
                                    .frame(alignment: .trailing)

                                }.frame(maxWidth: .infinity)
                                Spacer()
                            }
                        }
                        Box(store: store, geometry: geometry).padding()
                        Box(store: store, geometry: geometry).padding()
                    }
                }
                .ignoresSafeArea()
            }
            
            
            .sheet(isPresented: viewStore.binding(
                get: { $0.isConfigBeingPresented },
                send: { .configWalletPresented(isPresented: $0) }
            )) {
                ConfigaWalletView.init(store: Store(initialState: ConfigWallet.State()) { ConfigWallet().body })
            }.task {
                await viewStore.send(.task).finish()
            }
        }
    }
}

private struct MiniBox: View {
    let title: String
    let subtitle: String
    let width: Double
    
    var body: some View {
        VStack {
            Text(title)
            Text(subtitle)
        }
        .frame(width: width, height: width*0.82)
        .background(.red)
    }
}

struct Box: View {
    let store: StoreOf<Home>
    let geometry: GeometryProxy
    var miniboxWidth: Double { return (geometry.size.width - (Double(16) * Double(4))) / 3 }
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
    
    var body: some View {
            VStack {
                Text("INCREASING SPEED")
                Divider()
                HStack {
                    MiniBox(title: "Second", subtitle: "0.35€", width: miniboxWidth)
                    MiniBox(title: "Minute", subtitle: "0.35€", width: miniboxWidth)
                    MiniBox(title: "Hour", subtitle: "0.35€", width: miniboxWidth)
                }

                
                HStack {
                    MiniBox(title: "Day", subtitle: "0.35€", width: miniboxWidth)
                    MiniBox(title: "Month", subtitle: "0.35€", width: miniboxWidth)
                    MiniBox(title: "Year", subtitle: "0.35€", width: miniboxWidth)
                }
            }.background(.green)
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
