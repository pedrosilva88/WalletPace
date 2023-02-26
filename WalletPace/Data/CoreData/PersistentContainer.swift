import CoreData
import ComposableArchitecture
import XCTestDynamicOverlay

extension NSPersistentContainer {
    static let live: NSPersistentContainer = loadContainer(name: "WalletPace")
    
    private static func loadContainer(name: String) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "WalletPace")
        container.loadPersistentStores { description, error in
            if let error = error {
                 fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }

    public func saveContext() {
      let context = self.viewContext
      if context.hasChanges {
        do {
          try context.save()
        } catch {
          let nserror = error as NSError
          debugPrint("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
}


extension DependencyValues {
    public var persintenceContainer: NSPersistentContainer {
        get { self[NSPersistentContainer.self] }
        set { self[NSPersistentContainer.self] = newValue }
    }
}

extension NSPersistentContainer: TestDependencyKey {
    public static var previewValue: NSPersistentContainer = loadContainer(name: "WalletPaceDebug")
    public static var testValue: NSPersistentContainer = loadContainer(name: "WalletPaceTest")
    
}
