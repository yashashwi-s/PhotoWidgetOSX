import SwiftUI

@main
struct PhotoWidgetOSXApp: App {
    @StateObject private var manager = PhotoManager()

    var body: some Scene {
        MenuBarExtra("Photo Widget", systemImage: "photo.on.rectangle") {
            MenuBarView(manager: manager)
        }

        Window("Photo Widget", id: "settings") {
            ContentView(manager: manager)
                .frame(width: 420, height: 500)
        }
        .windowResizability(.contentSize)
    }
}
