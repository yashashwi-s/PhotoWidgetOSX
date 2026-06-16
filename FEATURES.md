# Photo Widget OSX — Features & Roadmap

## ✅ Shipped (v1.0.0) — Core Desktop Photo Widget

### Core
- [x] Desktop photo overlay — borderless `NSWindow` at `desktopIcon` level, always behind normal windows
- [x] True aspect ratio — window dimensions match the image exactly. No cropping, no letterboxing
- [x] Multiple independent photos — each gets its own window, position, size, lock state
- [x] Rounded corners (16px, continuous curve) + drop shadow for native macOS widget look

### Interaction
- [x] Drag to reposition anywhere on screen
- [x] Corner resize — drag any of the 4 corners, aspect ratio always locked
- [x] Lock position toggle (right-click or menu bar)
- [x] Cursor feedback — crosshair near corners, open hand in center

### Persistence
- [x] All state saved to `~/Library/Application Support/PhotoWidget/photos.json`
- [x] Photos stored as JPEG copies (90% quality) in the same directory
- [x] Position, size, lock state, visibility all restored on relaunch
- [x] Atomic save on quit (`NSApplication.willTerminate`)

### App Shell
- [x] Menu bar agent (`LSUIElement`) — no dock icon, no window clutter
- [x] Full `NSStatusItem` menu: add, show/hide, lock/unlock, remove per photo
- [x] Per-photo submenus with thumbnail previews
- [x] Right-click context menu directly on the photo overlay
- [x] Settings window with photo list, visibility toggles, remove buttons
- [x] Launch at Login via `SMAppService`
- [x] Hide menu bar icon (reopen app from Spotlight/Applications to restore)
- [x] Multi-select file picker (JPEG, PNG, HEIC, TIFF)
- [x] **Menu bar auto-refresh** — `NSMenuDelegate` rebuilds the menu every time it opens, always in sync with settings

### Performance
- [x] ~20MB RAM, zero CPU at idle — no timers, no polling, no background threads
- [x] Joins all Spaces (`canJoinAllSpaces`, `stationary`)

---

## ✅ Shipped (v1.1) — Floating Mode & Smart Canvas

### Floating Mode
- [x] **Window level toggle** — switch between desktop level (behind everything) and floating level (above everything). Stored per photo, persisted across relaunches
- [x] **Click-through (mouse passthrough)** — `ignoresMouseEvents = true` so the photo never steals focus
- [x] **Modifier key override** — hold `Option` to temporarily re-enable interaction on a click-through photo
- [x] **Opacity slider** — per-photo 10%–100%. Scroll-wheel on the photo to adjust quickly

### Naming & Organization
- [x] **Custom photo names** — rename from settings or menu bar
- [x] **Replace photo** — swaps the file but keeps position, size, lock, name, and all settings
- [x] **Duplicate photo** — creates a copy at a slightly offset position

### Aesthetic Controls (Per Photo)
- [x] **Corner radius slider** — 0px (sharp square) to 50px
- [x] **Shadow control** — toggle on/off, adjust blur radius and opacity
- [x] **Border** — adjustable width with color picker
- [x] **Edge fade (vignette)** — subtle fade-to-transparent at photo edges

### Smart Canvas (Folder Mode)
- [x] **Folder import** — point a widget at any folder. Only images are used (JPEG, PNG, HEIC, TIFF, GIF, WebP, BMP). Non-image files are silently ignored
- [x] **Folder watcher** — `DispatchSource` monitors the folder for changes in real-time
- [x] **Rotation intervals** — On Click, 30 seconds, 5 minutes, Hourly, Daily, Custom (user-defined seconds)
- [x] **Custom rotation** — text field for arbitrary interval in seconds (minimum 5s)
- [x] **Double-click to advance** — double-click the desktop photo to cycle to the next image (works even when locked)
- [x] **Per-image position & size** — each image in a folder remembers its own position and size independently via `FolderImageConfig`. Drag image A somewhere, switch to B, switch back — A is exactly where you left it
- [x] **GPU-accelerated crossfade** — `CATransition.fade` on the image layer for buttery-smooth image transitions
- [x] **Simultaneous frame animation** — window frame smoothly adjusts to each new image's aspect ratio in sync with the crossfade
- [x] **Top-left pin** — window pins its top-left corner during height changes so it doesn't jump around
- [x] **Photos.app integration** — pick directly from Photos library via `PhotosPicker` (up to 20 at once)

### Settings Panel Polish
- [x] **Hover backgrounds** — rows highlight on hover for clear interactivity feedback
- [x] **Clean expand/collapse** — `easeInOut(0.15s)`, no spring bounce, no transition artifacts
- [x] **Full-row click target** — click anywhere on the row header to expand/collapse (not just the chevron)
- [x] **Grouped settings** — MODE, APPEARANCE, SMART CANVAS sections with uppercase headers
- [x] **Consistent control sizes** — all sliders, toggles, pickers use `.controlSize(.small/.mini)` throughout

---

## 🔮 Roadmap

### v1.2 — Multi-Monitor & Spaces

macOS Spaces support is already partially there (`canJoinAllSpaces`), but there's more to do.

- [ ] **Per-display profiles** — remember which photos belong to which monitor. When a display disconnects, hide those photos. When it reconnects, restore them
- [ ] **Space binding** — optionally pin a photo to a specific Space instead of all Spaces
- [ ] **Snap to edges** — magnetic snapping when dragging near screen edges or other photos
- [ ] **Alignment guides** — show guides when a photo lines up with the edge or center of another photo

### v1.3 — Keyboard & CLI

Power user territory.

- [ ] **Global hotkey** — toggle all photos visible/hidden with a single shortcut (e.g., `⌘⇧P`)
- [ ] **CLI interface** — `photowidget add ~/path/to/image.jpg --floating --opacity 0.5` for scripting and automation
- [ ] **Apple Shortcuts support** — expose actions (add photo, toggle visibility, set opacity) to the Shortcuts app
- [ ] **URL scheme** — `photowidget://add?path=...` for integration with other apps

### v1.4 — Content Types

Expand beyond static images.

- [ ] **Animated GIF playback** — render GIFs natively on the desktop using `CALayer` animation
- [ ] **Screenshots from clipboard** — paste `⌘V` to instantly create a widget from clipboard image
- [ ] **Drag & drop onto menu bar icon** — drop an image file onto the status item to add it
- [ ] **Live web preview** — embed a `WKWebView` to display a live webpage (weather, calendar, dashboard) as a desktop widget
- [ ] **PDF pages** — display a specific page from a PDF, useful for cheat sheets and reference cards

### v1.5 — Grid Builder

An in-app interface for creating structured photo layouts as a single composite widget.

- [ ] **Grid canvas** — define rows and columns, drag photos into cells. The entire grid renders as one borderless window on the desktop
- [ ] **Snap mechanics** — photos snap to grid cells with magnetic alignment. Drag to reorder within the grid
- [ ] **Auto-layout** — choose from preset layouts (2×2, 3×1 filmstrip, 1+2 hero, masonry) or define custom row/column ratios
- [ ] **Per-cell controls** — each cell inherits the per-photo aesthetic controls (corner radius, border, opacity) independently
- [ ] **Grid as single object** — the composed grid moves, resizes, and locks as one unit. One entry in the menu bar, one entry in settings
- [ ] **Export grid** — render the current grid layout as a single high-res image for sharing or wallpaper use

### v1.6 — Smart Wallpaper Integration

Bridge the gap between desktop photos and system wallpaper.

- [ ] **Wallpaper-aware placement** — detect the current wallpaper's dominant colors and suggest optimal photo positions to avoid visual clashing
- [ ] **Automatic theme adaptation** — when macOS switches between Light/Dark mode, adjust border colors, shadow intensity, and opacity to maintain visual harmony
- [ ] **Time-based profiles** — different photo layouts for morning/afternoon/evening (tied to system appearance schedule)

### v1.7 — Collaboration & Sharing

Turn Photo Widget into a social/team tool.

- [ ] **Export configuration** — export a `.photowidget` bundle containing all photos, positions, sizes, and settings. Send to a teammate, they get the exact same layout
- [ ] **Import configuration** — drag a `.photowidget` file onto the app to import an entire layout
- [ ] **iCloud sync** — sync photo widgets across your Mac, including positions, settings, and images (opt-in per photo)
- [ ] **Shared folders** — point Smart Canvas at a shared iCloud/Dropbox folder so a team can push images to each other's desktops

### v1.8 — Scriptable Desktop

Ultimate power-user and automation features.

- [ ] **AppleScript dictionary** — full scriptability: add/remove photos, set properties, query state
- [ ] **Raycast extension** — search, toggle, and manage photos directly from Raycast
- [ ] **Alfred workflow** — same for Alfred users
- [ ] **Accessibility labels** — VoiceOver support for all interactive elements
- [ ] **Plugin API** — expose a lightweight API for third-party plugins to add custom content types (clocks, calendars, system monitors)

---

## Architecture

```
Sources/App/
├── PhotoWidgetOSXApp.swift   # @main — delegates everything to AppDelegate
├── AppDelegate.swift         # NSStatusItem menu (NSMenuDelegate) + settings window lifecycle
├── ContentView.swift         # SwiftUI settings UI (photo list, toggles, PhotosPicker, grouped controls)
├── DesktopPhotoWindow.swift  # Borderless NSWindow + DraggablePhotoView (drag/resize/right-click/crossfade)
├── PhotoItem.swift           # Codable model: all per-photo settings + FolderImageConfig
├── ImageManager.swift        # PhotoManager — add/remove/persist + window creation + folder sync + rotation
├── FolderWatcher.swift       # GCD DispatchSource folder monitor for Smart Canvas
└── Assets.xcassets/
    └── AppIcon.appiconset/   # 16px–1024px icon variants
```

**Storage:**
```
~/Library/Application Support/PhotoWidget/
├── photos.json               # Array of PhotoItem (atomic write, pretty-printed)
│                              # Includes per-image FolderImageConfig for folder photos
└── *.jpg                     # JPEG copies at 90% quality (single-image photos only)
```

**Key Design Decisions:**
- `NSMenuDelegate.menuNeedsUpdate` rebuilds the menu lazily each time it opens — always in sync
- `FolderImageConfig` stores per-image position/size keyed by filename within each `PhotoItem`
- `CATransition.fade` for GPU-accelerated crossfade, simultaneous with `NSAnimationContext` frame animation
- All SwiftUI animations use `easeInOut` only — no springs, no bounces, matching native macOS behavior
- Settings panel uses hover state + background transitions for interactive feedback
