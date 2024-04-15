import ComposableArchitecture

struct Home: ReducerProtocol {
    struct State: Equatable {
        var wallet: Wallet?
        var liabilities: [Liability] = []
        var incomes: [Income] = []
        
        var amount: Double { wallet?.amount ?? 0 }
        
        var walletInAWeek: Double { amount + (incrementPace*60*60*24*7) }
        var walletInAMonth: Double { amount + (incrementPace*60*60*24*30) }
        var walletInAYear: Double { amount + (incrementPace*60*60*24*365) }
        var walletOnYearEnd: Double { 0 }
        
        var incrementInASecond: Double { incrementPace }
        var incrementInAMinute: Double { incrementPace*60 }
        var incrementInAHour: Double { incrementPace*60*60 }
        var incrementInADay: Double { incrementPace*60*60*24 }
        var incrementInAMonth: Double { incrementPace*60*60*24*30 }
        var incrementInAYear: Double { incrementPace*60*60*24*30*12 }
        
        var incrementPace: Double {
            let sumIncome = incomes.reduce(0, { return $0 + $1.amount })
            let sumLiability = liabilities.reduce(0, { return $0 + $1.amount })
            // its being measured by month
            return ((sumIncome*12/365/24/60/60) - (sumLiability*12/365/24/60/60))
        }
        
        var isConfigBeingPresented: Bool = false {
            didSet {
                print(self.isConfigBeingPresented)
            }
        }
        
        private var _configWalletState = ConfigWallet.State()
    }

    enum Action: Equatable {
        case task
        case updateWalletAmount
        case configWalletPresented(isPresented: Bool)
        case configWallet(ConfigWallet.Action)
        case walletResponse(Wallet?)
        case incomesResponse([Income])
        case liabilitiesResponse([Liability])
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.walletManager) var walletManager
    struct HomeCancelId: Hashable {}

    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.configWallet, action: /Action.configWallet) {
            ConfigWallet()
        }
        
        Reduce { state, action in
            switch action {
            case .task:
                return .merge(
                    .run { send in
                        for await _ in clock.timer(interval: .seconds(1)) {
                            await send(.updateWalletAmount)
                        }}
//                    ,
                    
//                    coredata.wallet()
//                        .map(Home.Action.walletResponse)
//                        .cancellable(id: HomeCancelId()),
//                    
//                    coredata.incomes()
//                        .map(Home.Action.incomesResponse)
//                        .cancellable(id: HomeCancelId()),
//
//                    coredata.liabilities()
//                        .map(Home.Action.liabilitiesResponse)
//                        .cancellable(id: HomeCancelId())
                    )

            case .updateWalletAmount:
                guard !state.isConfigBeingPresented else { return .none }

                return walletManager.syncWallet()
                    .map(Home.Action.walletResponse)
                    .cancellable(id: HomeCancelId())
                
            case let .configWalletPresented(isPresented: isPresented):
                state.isConfigBeingPresented = isPresented
                return .none
                
            case .configWallet:
                return .none
                
            case .walletResponse(let wallet):
                state.wallet = wallet
                return .none
                
            case .incomesResponse(let incomes):
                state.incomes = incomes
                return .none
                
            case .liabilitiesResponse(let liabilities):
                state.liabilities = liabilities
                return .none
            }
        }
    }
}

extension Home.State {
    var configWallet: ConfigWallet.State {
        get {
            ConfigWallet.State(wallet: self.wallet,
                               incomes: self.incomes,
                               liabilities: self.liabilities,
                               currentWalletValue: _configWalletState.currentWalletValue,
                               currentAmountValue: _configWalletState.currentAmountValue,
                               tabSelected: _configWalletState.tabSelected,
                               isPresentingAddItemView: _configWalletState.isPresentingAddItemView)
        }
        set {
            self.wallet = newValue.wallet
            self.incomes = newValue.incomes
            self.liabilities = newValue.liabilities
            _configWalletState = newValue
        }
    }
}
