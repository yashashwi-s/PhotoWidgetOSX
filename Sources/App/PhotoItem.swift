import Foundation

/// Represents a single photo placed on the desktop.
struct PhotoItem: Identifiable, Codable {
    let id: UUID
    var filename: String        // stored in app support dir
    var frameString: String     // NSStringFromRect
    var widgetWidth: CGFloat
    var isLocked: Bool
    var isVisible: Bool

    init(filename: String, width: CGFloat = 300) {
        self.id = UUID()
        self.filename = filename
        self.frameString = ""
        self.widgetWidth = width
        self.isLocked = false
        self.isVisible = true
    }
}
