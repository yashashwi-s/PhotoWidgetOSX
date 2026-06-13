import SwiftUI

/// Menu bar dropdown for quick controls.
struct MenuBarView: View {
    @ObservedObject var manager: PhotoManager

    var body: some View {
        Button("Add Photo…") {
            pickFile()
        }

        if !manager.photos.isEmpty {
            Divider()

            ForEach(manager.photos) { item in
                let label = item.isVisible ? "Hide" : "Show"
                let icon = item.isVisible ? "eye.slash" : "eye"
                Button {
                    manager.toggleVisibility(item.id)
                } label: {
                    Label("\(label) Photo", systemImage: icon)
                }
            }

            Divider()

            Button("Remove All") {
                manager.removeAllPhotos()
            }
        }

        Divider()

        Toggle("Launch at Login", isOn: Binding(
            get: { manager.launchAtLogin },
            set: { manager.setLaunchAtLogin($0) }
        ))

        Divider()

        Button("Quit Photo Widget") {
            NSApp.terminate(nil)
        }
        .keyboardShortcut("q")
    }

    private func pickFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image, .png, .jpeg, .heic, .tiff]
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.prompt = "Add"

        NSApp.activate(ignoringOtherApps: true)

        if panel.runModal() == .OK {
            for url in panel.urls {
                if let img = NSImage(contentsOf: url) {
                    manager.addPhoto(img)
                }
            }
        }
    }
}
