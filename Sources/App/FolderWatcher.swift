import Foundation

/// Lightweight folder watcher using GCD DispatchSource.
/// Monitors a directory for file changes and calls back with the updated image file list.
final class FolderWatcher {
    private var source: DispatchSourceFileSystemObject?
    private var fileDescriptor: Int32 = -1
    private let queue = DispatchQueue(label: "com.yashashwi.photowidget.folderwatcher", qos: .utility)

    let folderURL: URL
    var onChange: (([URL]) -> Void)?

    private static let imageExtensions: Set<String> = ["jpg", "jpeg", "png", "heic", "tiff", "tif", "gif", "webp", "bmp"]

    init(folderURL: URL) {
        self.folderURL = folderURL
    }

    deinit {
        stop()
    }

    /// Start watching the folder for changes.
    func start() {
        stop()

        let fd = open(folderURL.path, O_EVTONLY)
        guard fd >= 0 else { return }
        fileDescriptor = fd

        let src = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fd,
            eventMask: [.write, .rename, .delete],
            queue: queue
        )

        src.setEventHandler { [weak self] in
            guard let self else { return }
            let files = self.scanImages()
            DispatchQueue.main.async {
                self.onChange?(files)
            }
        }

        src.setCancelHandler { [weak self] in
            guard let self else { return }
            if self.fileDescriptor >= 0 {
                close(self.fileDescriptor)
                self.fileDescriptor = -1
            }
        }

        source = src
        src.resume()
    }

    /// Stop watching.
    func stop() {
        source?.cancel()
        source = nil
    }

    func scanImages() -> [URL] {
        guard let paths = try? FileManager.default.contentsOfDirectory(atPath: folderURL.path) else { return [] }

        return paths
            .filter { Self.imageExtensions.contains(($0 as NSString).pathExtension.lowercased()) }
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }
            .map { folderURL.appendingPathComponent($0) }
    }
}
