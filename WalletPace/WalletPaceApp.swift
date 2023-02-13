//
//  WalletPaceApp.swift
//  WalletPace
//
//  Created by Pedro Silva on 11/02/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct WalletPaceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView(store: Store(initialState: Home.State(), reducer: Home()))
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
