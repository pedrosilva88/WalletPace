//
//  WalletPaceApp.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import SwiftUI
import Combine
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
    
    var cancellables: [AnyCancellable] = []
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.home, action: /Action.home) {
            Home()
        }
        
        Reduce { state, action in
            switch action {
            case .appDelegate(.didFinishLaunching):
                coredata.wallet().sink(receiveValue: { wallet in
                    print(wallet)
                })
                
                return EffectTask.merge(
                    coredata.wallet()
                        .receive(on: DispatchQueue.main)
//                        .replaceError(with: nil)
                        .eraseToEffect()
                        .map({ wallet in
                            print("Ole",wallet)
                            return Action.home(.walletResponse(wallet))
                        }),
                    
                    coredata.incomes()
                        .receive(on: DispatchQueue.main)
                        .replaceError(with: [])
                        .eraseToEffect()
                        .map({ incomes in
                            return Action.home(.incomesResponse(incomes))
                        }),
                    
                    coredata.liabilities()
                        .receive(on: DispatchQueue.main)
                        .replaceError(with: [])
                        .eraseToEffect()
                        .map({ liabilities in
                            return Action.home(.liabilitiesResponse(liabilities))
                        })
                )
            default: return .none
            }
            
        }
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(
        initialState: AppReducer.State(),
        reducer: AppReducer().dependency(\.coredata, .live)
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
            HomeView(store: appDelegate.store.scope(state: \.home, action: AppReducer.Action.home)).tint(.black)
        }
    }
}
