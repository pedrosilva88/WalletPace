//
//  WalletPaceApp.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import SwiftUI
import ComposableArchitecture

struct AppReducer: ReducerProtocol {
    struct State: Equatable {
        var home: Home.State
        
        public init(home: Home.State = .init()) {
            self.home = home
        }
    }
    enum Action {
        case appDelegate(AppDelegateReducer.Action)
        case home(Home.Action)
    }
    
    @Dependency(\.coredata) var coredata
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.home, action: /Action.home) {
            Home()
        }
        
        Reduce { state, action in
            switch action {
            case .appDelegate(.didFinishLaunching):
                state.home.wallet = coredata.fetchWallet()
                return .none
            default: return .none
            }
            
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(
      initialState: AppReducer.State(),
      reducer: AppReducer().dependency(\.coredata, .live())
    )

    var viewStore: ViewStore<Void, AppReducer.Action> {
      ViewStore(self.store.stateless)
    }

    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
      self.viewStore.send(.appDelegate(.didFinishLaunching))
      return true
    }
  }

@main
struct WalletPaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    init() {}
    
    var body: some Scene {
        WindowGroup {
            HomeView(store: appDelegate.store.scope(state: \.home, action: AppReducer.Action.home))
        }
//        .onChange(of: self.scenePhase) {
//            self.appDelegate.viewStore.send(.didChangeScenePhase($0))
//          }
    }
}
