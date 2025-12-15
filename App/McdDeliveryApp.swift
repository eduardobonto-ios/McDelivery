import SwiftUI
import Firebase

@main
struct McdDeliveryApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
