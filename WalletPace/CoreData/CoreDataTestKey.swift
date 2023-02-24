//
//  CoreDataTestKey.swift
//  WalletPace
//
//  Created by Pedro Silva on 20/02/2023.
//

import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    public var coredata: CoreData {
        get { self[CoreData.self] }
        set { self[CoreData.self] = newValue }
    }
}

extension CoreData: TestDependencyKey {
    public static let previewValue = Self.mock
    
    public static let testValue = Self()
}

extension CoreData {
    public static var mock: Self {
        return Self()
    }
}
