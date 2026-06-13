import AppKit
import SwiftUI

/// A borderless, always-on-desktop window that displays a photo
/// at its exact aspect ratio with rounded corners, shadow, and resize handles.
class DesktopPhotoWindow: NSWindow {
    var photoId: UUID?
    var onDoubleClick: (() -> Void)?
    var onResize: ((CGFloat) -> Void)?

    init() {
        super.init(
            contentRect: NSRect(x: 100, y: 100, width: 300, height: 300),
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)) + 1)
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        ignoresMouseEvents = false
        isMovable = true
        isMovableByWindowBackground = true
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        hidesOnDeactivate = false
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    func showPhoto(_ image: NSImage, baseWidth: CGFloat = 300, locked: Bool = false) {
        let imageSize = image.size
        guard imageSize.width > 0, imageSize.height > 0 else { return }

        let aspectRatio = imageSize.width / imageSize.height
        let windowWidth = baseWidth
        let windowHeight = windowWidth / aspectRatio

        let container = DraggablePhotoView(
            frame: NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight),
            image: image,
            locked: locked
        )
        container.onDoubleClick = { [weak self] in self?.onDoubleClick?() }
        container.onResize = { [weak self] newWidth in self?.onResize?(newWidth) }

        contentView = container
        setContentSize(NSSize(width: windowWidth, height: windowHeight))
        makeKeyAndOrderFront(nil)
    }

    func hidePhoto() { orderOut(nil) }

    func setLocked(_ locked: Bool) {
        (contentView as? DraggablePhotoView)?.isLocked = locked
    }

    func resizeTo(width: CGFloat) {
        guard let container = contentView as? DraggablePhotoView,
              let image = container.photoImage else { return }
        let aspectRatio = image.size.width / image.size.height
        let newHeight = width / aspectRatio

        var newFrame = frame
        newFrame.size = NSSize(width: width, height: newHeight)
        setFrame(newFrame, display: true, animate: true)

        container.frame = NSRect(x: 0, y: 0, width: width, height: newHeight)
        container.imageView.frame = container.bounds
    }
}

// MARK: - Resize Edge

enum ResizeEdge {
    case none
    case left, right, top, bottom
    case topLeft, topRight, bottomLeft, bottomRight
}

// MARK: - Draggable Photo View

class DraggablePhotoView: NSView {
    let imageView: NSImageView
    var photoImage: NSImage? { imageView.image }
    var isLocked = false
    var onDoubleClick: (() -> Void)?
    var onResize: ((CGFloat) -> Void)?

    private var initialMouseLocation: NSPoint = .zero
    private var initialWindowOrigin: NSPoint = .zero
    private var initialWindowSize: NSSize = .zero
    private var activeEdge: ResizeEdge = .none
    private let handleSize: CGFloat = 8

    init(frame: NSRect, image: NSImage, locked: Bool = false) {
        imageView = NSImageView(frame: NSRect(origin: .zero, size: frame.size))
        imageView.image = image
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.wantsLayer = true
        imageView.layer?.cornerRadius = 16
        imageView.layer?.masksToBounds = true
        imageView.layer?.cornerCurve = .continuous
        self.isLocked = locked

        super.init(frame: frame)

        wantsLayer = true
        shadow = NSShadow()
        shadow?.shadowColor = NSColor.black.withAlphaComponent(0.3)
        shadow?.shadowOffset = NSSize(width: 0, height: -2)
        shadow?.shadowBlurRadius = 10

        addSubview(imageView)

        // Track mouse for cursor changes
        let trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.activeAlways, .mouseMoved, .inVisibleRect, .mouseEnteredAndExited],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackingArea)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Hit Testing

    private func edgeAt(_ point: NSPoint) -> ResizeEdge {
        let h = handleSize
        let w = bounds.width
        let ht = bounds.height

        let onLeft = point.x < h
        let onRight = point.x > w - h
        let onBottom = point.y < h
        let onTop = point.y > ht - h

        if onTop && onLeft { return .topLeft }
        if onTop && onRight { return .topRight }
        if onBottom && onLeft { return .bottomLeft }
        if onBottom && onRight { return .bottomRight }
        if onLeft { return .left }
        if onRight { return .right }
        if onTop { return .top }
        if onBottom { return .bottom }
        return .none
    }

    private func isCorner(_ edge: ResizeEdge) -> Bool {
        switch edge {
        case .topLeft, .topRight, .bottomLeft, .bottomRight: return true
        default: return false
        }
    }

    // MARK: - Cursor

    override func mouseMoved(with event: NSEvent) {
        if isLocked { NSCursor.arrow.set(); return }
        let point = convert(event.locationInWindow, from: nil)
        let edge = edgeAt(point)
        switch edge {
        case .left, .right:
            NSCursor.resizeLeftRight.set()
        case .top, .bottom:
            NSCursor.resizeUpDown.set()
        case .topLeft, .bottomRight:
            // Diagonal — use a standard arrow with resize semantics
            NSCursor.crosshair.set()
        case .topRight, .bottomLeft:
            NSCursor.crosshair.set()
        case .none:
            NSCursor.openHand.set()
        }
    }

    override func mouseExited(with event: NSEvent) {
        NSCursor.arrow.set()
    }

    override func cursorUpdate(with event: NSEvent) {
        // Prevent system cursor overrides
    }

    // MARK: - Mouse Events

    override func mouseDown(with event: NSEvent) {
        if event.clickCount == 2 {
            onDoubleClick?()
            return
        }
        if isLocked { return }

        let point = convert(event.locationInWindow, from: nil)
        activeEdge = edgeAt(point)
        initialMouseLocation = NSEvent.mouseLocation
        initialWindowOrigin = window?.frame.origin ?? .zero
        initialWindowSize = window?.frame.size ?? .zero
    }

    override func mouseDragged(with event: NSEvent) {
        if isLocked { return }
        guard let window = window, let image = photoImage else { return }

        let currentMouse = NSEvent.mouseLocation
        let dx = currentMouse.x - initialMouseLocation.x
        let dy = currentMouse.y - initialMouseLocation.y

        if activeEdge == .none {
            // Move
            let newOrigin = NSPoint(
                x: initialWindowOrigin.x + dx,
                y: initialWindowOrigin.y + dy
            )
            window.setFrameOrigin(newOrigin)
            return
        }

        // Resize
        let aspectRatio = image.size.width / image.size.height
        let minWidth: CGFloat = 100
        let maxWidth: CGFloat = 1200

        var newWidth = initialWindowSize.width
        var newHeight = initialWindowSize.height
        var newX = initialWindowOrigin.x
        var newY = initialWindowOrigin.y

        if isCorner(activeEdge) {
            // CORNERS: maintain aspect ratio
            // Use the larger delta to drive the resize
            let absDx = abs(dx)
            let absDy = abs(dy)
            let delta = absDx > absDy ? dx : dy * aspectRatio

            switch activeEdge {
            case .bottomRight:
                newWidth = max(minWidth, min(maxWidth, initialWindowSize.width + delta))
                newHeight = newWidth / aspectRatio
            case .bottomLeft:
                newWidth = max(minWidth, min(maxWidth, initialWindowSize.width - delta))
                newHeight = newWidth / aspectRatio
                newX = initialWindowOrigin.x + (initialWindowSize.width - newWidth)
            case .topRight:
                newWidth = max(minWidth, min(maxWidth, initialWindowSize.width + delta))
                newHeight = newWidth / aspectRatio
                newY = initialWindowOrigin.y + (initialWindowSize.height - newHeight)
            case .topLeft:
                newWidth = max(minWidth, min(maxWidth, initialWindowSize.width - delta))
                newHeight = newWidth / aspectRatio
                newX = initialWindowOrigin.x + (initialWindowSize.width - newWidth)
                newY = initialWindowOrigin.y + (initialWindowSize.height - newHeight)
            default: break
            }
        } else {
            // EDGES: free resize (stretches)
            switch activeEdge {
            case .right:
                newWidth = max(minWidth, min(maxWidth, initialWindowSize.width + dx))
            case .left:
                newWidth = max(minWidth, min(maxWidth, initialWindowSize.width - dx))
                newX = initialWindowOrigin.x + (initialWindowSize.width - newWidth)
            case .top:
                newHeight = max(minWidth / aspectRatio, initialWindowSize.height + dy)
                newY = initialWindowOrigin.y // anchor bottom
            case .bottom:
                newHeight = max(minWidth / aspectRatio, initialWindowSize.height - dy)
                newY = initialWindowOrigin.y + (initialWindowSize.height - newHeight)
            default: break
            }

            // For edge resizes, don't force aspect ratio — let user stretch
            if activeEdge == .left || activeEdge == .right {
                newHeight = initialWindowSize.height // keep height
            } else {
                newWidth = initialWindowSize.width // keep width
            }
        }

        let newFrame = NSRect(x: newX, y: newY, width: newWidth, height: newHeight)
        window.setFrame(newFrame, display: true)

        // Update image view to fill
        imageView.frame = NSRect(x: 0, y: 0, width: newWidth, height: newHeight)
        frame = NSRect(x: 0, y: 0, width: newWidth, height: newHeight)
    }

    override func mouseUp(with event: NSEvent) {
        if isLocked { return }
        if let window = window {
            // Notify for position/size saving
            NotificationCenter.default.post(name: .desktopPhotoMoved, object: window)

            // Report new width for slider sync
            if activeEdge != .none {
                onResize?(window.frame.width)
            }
        }
        activeEdge = .none
        NSCursor.arrow.set()
    }

    override var acceptsFirstResponder: Bool { true }
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool { true }

    override func hitTest(_ point: NSPoint) -> NSView? {
        return bounds.contains(point) ? self : nil
    }

    /// Flash a lock/unlock icon.
    func flashLockState(_ locked: Bool) {
        let size: CGFloat = 48
        let indicator = NSView(frame: NSRect(
            x: (bounds.width - size) / 2,
            y: (bounds.height - size) / 2,
            width: size, height: size
        ))
        indicator.wantsLayer = true
        indicator.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.6).cgColor
        indicator.layer?.cornerRadius = 12

        let symbol = NSImageView(frame: NSRect(x: 8, y: 8, width: 32, height: 32))
        let config = NSImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        symbol.image = NSImage(
            systemSymbolName: locked ? "lock.fill" : "lock.open.fill",
            accessibilityDescription: nil
        )?.withSymbolConfiguration(config)
        symbol.contentTintColor = .white
        indicator.addSubview(symbol)
        addSubview(indicator)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            NSAnimationContext.runAnimationGroup { ctx in
                ctx.duration = 0.3
                indicator.animator().alphaValue = 0
            } completionHandler: {
                indicator.removeFromSuperview()
            }
        }
    }
}

// MARK: - Notification

extension Notification.Name {
    static let desktopPhotoMoved = Notification.Name("desktopPhotoMoved")
}
