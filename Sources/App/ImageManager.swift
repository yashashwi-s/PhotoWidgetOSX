import AppKit
import SwiftUI
import ServiceManagement

/// Manages multiple desktop photos, persistence, and app settings.
@MainActor
class PhotoManager: ObservableObject {
    @Published var photos: [PhotoItem] = []
    @Published var launchAtLogin: Bool = false
    @Published var showMenuBarIcon: Bool = true

    private var windows: [UUID: DesktopPhotoWindow] = [:]

    /// App Support directory for storing photos.
    private var storageDir: URL {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = support.appendingPathComponent("PhotoWidget", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    /// Where we persist the photo list.
    private var dataFile: URL { storageDir.appendingPathComponent("photos.json") }

    init() {
        // Check current launch-at-login state
        launchAtLogin = SMAppService.mainApp.status == .enabled
        showMenuBarIcon = UserDefaults.standard.object(forKey: "showMenuBarIcon") as? Bool ?? true

        // Listen for window-move notifications
        NotificationCenter.default.addObserver(
            forName: .desktopPhotoMoved,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let window = notification.object as? DesktopPhotoWindow,
                  let id = window.photoId else { return }
            Task { @MainActor [weak self] in
                self?.saveWindowPosition(for: id, frame: window.frame)
            }
        }
    }

    // MARK: - Load & Save

    func loadSaved() {
        guard let data = try? Data(contentsOf: dataFile),
              let items = try? JSONDecoder().decode([PhotoItem].self, from: data) else { return }
        photos = items

        for item in photos where item.isVisible {
            let imageURL = storageDir.appendingPathComponent(item.filename)
            guard let image = NSImage(contentsOf: imageURL) else { continue }
            showWindow(for: item, image: image)
        }
    }

    private func persist() {
        let data = try? JSONEncoder().encode(photos)
        try? data?.write(to: dataFile)
    }

    // MARK: - Add / Remove Photos

    func addPhoto(_ image: NSImage) {
        // Save image to disk
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        guard let jpegData = bitmapRep.representation(using: .jpeg, properties: [.compressionFactor: 0.9]) else { return }

        let filename = UUID().uuidString + ".jpg"
        let fileURL = storageDir.appendingPathComponent(filename)
        try? jpegData.write(to: fileURL)

        var item = PhotoItem(filename: filename)
        photos.append(item)
        showWindow(for: item, image: image)
        persist()
    }

    func removePhoto(_ id: UUID) {
        guard let index = photos.firstIndex(where: { $0.id == id }) else { return }
        let item = photos[index]

        // Remove window
        windows[id]?.hidePhoto()
        windows.removeValue(forKey: id)

        // Remove file
        let fileURL = storageDir.appendingPathComponent(item.filename)
        try? FileManager.default.removeItem(at: fileURL)

        photos.remove(at: index)
        persist()
    }

    func removeAllPhotos() {
        for id in Array(windows.keys) {
            removePhoto(id)
        }
    }

    // MARK: - Window Management

    private func showWindow(for item: PhotoItem, image: NSImage) {
        let window = DesktopPhotoWindow()
        window.photoId = item.id
        window.showPhoto(image, baseWidth: item.widgetWidth, locked: item.isLocked)

        // Restore position
        if !item.frameString.isEmpty {
            let rect = NSRectFromString(item.frameString)
            if rect.width > 0 {
                window.setFrameOrigin(rect.origin)
            }
        }

        // Double-click toggles lock
        window.onDoubleClick = { [weak self] in
            self?.toggleLock(item.id)
        }

        // Sync slider when user resizes via drag handles
        window.onResize = { [weak self] newWidth in
            guard let self = self,
                  let index = self.photos.firstIndex(where: { $0.id == item.id }) else { return }
            self.photos[index].widgetWidth = newWidth
            self.persist()
        }

        windows[item.id] = window
    }

    // MARK: - Controls

    func toggleLock(_ id: UUID) {
        guard let index = photos.firstIndex(where: { $0.id == id }) else { return }
        photos[index].isLocked.toggle()
        let locked = photos[index].isLocked

        windows[id]?.setLocked(locked)
        (windows[id]?.contentView as? DraggablePhotoView)?.flashLockState(locked)

        persist()
    }

    func toggleVisibility(_ id: UUID) {
        guard let index = photos.firstIndex(where: { $0.id == id }) else { return }
        photos[index].isVisible.toggle()

        if photos[index].isVisible {
            let item = photos[index]
            let imageURL = storageDir.appendingPathComponent(item.filename)
            if let image = NSImage(contentsOf: imageURL) {
                showWindow(for: item, image: image)
            }
        } else {
            windows[id]?.hidePhoto()
            windows.removeValue(forKey: id)
        }

        persist()
    }

    func resize(_ id: UUID, to width: CGFloat) {
        guard let index = photos.firstIndex(where: { $0.id == id }) else { return }
        photos[index].widgetWidth = width
        windows[id]?.resizeTo(width: width)
        persist()
    }

    private func saveWindowPosition(for id: UUID, frame: NSRect) {
        guard let index = photos.firstIndex(where: { $0.id == id }) else { return }
        photos[index].frameString = NSStringFromRect(frame)
        persist()
    }

    // MARK: - Settings

    func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            launchAtLogin = enabled
        } catch {
            print("Launch at login error: \(error)")
        }
    }

    func setShowMenuBarIcon(_ show: Bool) {
        showMenuBarIcon = show
        UserDefaults.standard.set(show, forKey: "showMenuBarIcon")
    }

    /// Thumbnail of a photo for the UI.
    func thumbnail(for item: PhotoItem) -> NSImage? {
        let url = storageDir.appendingPathComponent(item.filename)
        return NSImage(contentsOf: url)
    }
}
