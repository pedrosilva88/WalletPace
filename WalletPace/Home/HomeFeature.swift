//
//  HomeState.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import Foundation
import ComposableArchitecture

struct Home: ReducerProtocol {
    struct State: Equatable {
        var value: Float = 0
    }

    enum Action: Equatable {
        case onAppear
        case updateValue
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            struct TimerId: Hashable {}       
            return EffectTask.timer(id: TimerId(), every: 1, on: DispatchQueue.main)
                .map{ _ in .updateValue}
        case .updateValue:
            state.value += 0.2
            return .none
        }
    }
}
