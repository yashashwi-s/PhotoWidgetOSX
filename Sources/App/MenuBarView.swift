import SwiftUI

/// Menu bar dropdown with per-photo controls and thumbnails.
struct MenuBarView: View {
    @ObservedObject var manager: PhotoManager

    var body: some View {
        Button("Add Photo…") { pickFile() }

        if !manager.photos.isEmpty {
            Divider()

            ForEach(manager.photos) { item in
                Menu(manager.label(for: item)) {
                    Button(item.isVisible ? "Hide" : "Show") {
                        manager.toggleVisibility(item.id)
                    }

                    Button(item.isLocked ? "Unlock Position" : "Lock Position") {
                        manager.toggleLock(item.id)
                    }

                    Divider()

                    Button("Remove") {
                        manager.removePhoto(item.id)
                    }
                }
            }

            Divider()

            Button("Remove All Photos") {
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
