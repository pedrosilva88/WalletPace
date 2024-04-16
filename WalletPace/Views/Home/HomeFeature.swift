import ComposableArchitecture

@Reducer
struct Home {
    @ObservableState
    struct State: Equatable {
        var wallet: WalletViewModel?
        var amount: Double { wallet?.amount ?? 0 }
        
        var isConfigBeingPresented: Bool = false {
            didSet {
                print(self.isConfigBeingPresented)
            }
        }
    }

    enum Action: Equatable {
        case task
        case syncWallet
        case configWalletPresented(isPresented: Bool)
        case walletResponse(Wallet?)
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.walletManager) var walletManager
    struct HomeCancelId: Hashable {}
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .task:
                return .merge(
                    .send(.syncWallet),
                    .run { send in
                        for await _ in clock.timer(interval: .seconds(1)) {
                            await send(.syncWallet)
                        }}
                    )

            case .syncWallet:
                guard !state.isConfigBeingPresented else { return .none }

                return walletManager.syncWallet()
                    .map(Home.Action.walletResponse)
                    .cancellable(id: HomeCancelId())
                
            case let .configWalletPresented(isPresented: isPresented):
                state.isConfigBeingPresented = isPresented
                return .none
                
            case .walletResponse(let wallet):
                state.wallet = WalletViewModel(amount: wallet?.amount ?? 0)
                return .none
            }
        }
    }
}
