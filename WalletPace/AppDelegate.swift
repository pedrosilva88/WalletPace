//
//  AppDelegate.swift
//  WalletPace
//
//  Created by Pedro Silva on 20/02/2023.
//

import ComposableArchitecture

@Reducer
struct AppDelegateReducer {
    @ObservableState
    struct State: Equatable { }
    
    enum Action: Equatable {
        case didFinishLaunching
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didFinishLaunching:
                return .none
            }
        }
    }
}

