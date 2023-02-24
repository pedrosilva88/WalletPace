//
//  AppDelegate.swift
//  WalletPace
//
//  Created by Pedro Silva on 20/02/2023.
//

import ComposableArchitecture

public struct AppDelegateReducer: ReducerProtocol {
    public struct State: Equatable { }
    
    public enum Action: Equatable {
        case didFinishLaunching
    }
    
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
}

