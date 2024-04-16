//
//  WalletPaceApp.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import SwiftUI
import SwiftData
import Combine
import ComposableArchitecture

@Reducer
struct AppReducer {
    @ObservableState
    struct State: Equatable {}
    enum Action {
        case willFinishLaunching
    }
    
    @Dependency(\.walletManager) var walletManager
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .willFinishLaunching:
                _ = walletManager.syncWallet()
                return .none
            }
            
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store: StoreOf<AppReducer> = Store(
        initialState: AppReducer.State(),
        reducer: { AppReducer() }) { $0.walletManager = .liveValue }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        store.send(.willFinishLaunching)
        return true
    }
}

@main
struct WalletPaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    init() {}
    
    var body: some Scene {
        WindowGroup {
            HomeView(store: Store(initialState: Home.State(), 
                                  reducer: { Home().body },
                                  withDependencies: {
                $0.walletManager = .liveValue
            }))
        }
    }
}
