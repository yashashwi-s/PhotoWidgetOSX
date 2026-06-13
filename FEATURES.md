# Photo Widget — Features

## ✅ Implemented

### Core
- [x] **Desktop photo overlay** — borderless window at desktop level, sits behind all normal windows
- [x] **Exact aspect ratio matching** — widget size is computed from the image's native dimensions
- [x] **Multiple photos** — add as many images as you want, each gets its own window
- [x] **Rounded corners** — 16px continuous corners matching native macOS widget aesthetic
- [x] **Drop shadow** — subtle shadow for depth, just like system widgets

### Interaction
- [x] **Drag to reposition** — click and drag anywhere on the photo to move it
- [x] **Lock position** — double-click to toggle lock (shows lock/unlock icon flash)
- [x] **Resize from corners** — maintains aspect ratio (proportional scaling)
- [x] **Resize from edges** — free stretch (allows changing aspect ratio)
- [x] **Resize via slider** — per-photo size slider in settings (150–800px range)
- [x] **Cursor feedback** — cursor changes to resize arrows/crosshair near edges/corners

### Persistence
- [x] **Remember photos** — saved as JPEG in Application Support
- [x] **Remember positions** — window frame persisted per photo
- [x] **Remember sizes** — widget width persisted per photo
- [x] **Remember lock state** — lock/unlock state persisted per photo
- [x] **Remember visibility** — show/hide state persisted per photo
- [x] **All state survives restarts** — everything loads back on app launch

### App
- [x] **Menu bar app** — lives in menu bar, no dock icon clutter (LSUIElement)
- [x] **Menu bar controls** — add photo, show/hide each, remove all, quit
- [x] **Settings window** — photo list with per-photo controls
- [x] **Launch at Login** — toggle in settings, uses SMAppService
- [x] **Multi-select file picker** — add multiple photos at once
- [x] **Show/Hide per photo** — eye icon toggle in settings and menu bar
- [x] **Per-photo controls** — lock, visibility, size, delete for each photo

### Performance
- [x] **Ultra lightweight** — ~20-30MB RAM, zero CPU when idle (static image, no timers)
- [x] **Efficient storage** — JPEG compression at 90% quality
- [x] **No background processing** — completely idle when not being interacted with

---

## 🔮 Future Features

### v1.1 — Polish
- [ ] **App icon** — custom app icon for menu bar and About dialog
- [ ] **Right-click context menu on photo** — lock, resize, remove, bring to front
- [ ] **Keyboard shortcuts** — ⌘H to hide all, ⌘L to lock all
- [ ] **Snap to grid** — hold Shift while dragging to snap to alignment grid
- [ ] **Multi-monitor support** — remember which display each photo is on

### v1.2 — Customization
- [ ] **Custom corner radius** — slider to adjust from sharp (0) to pill-shaped
- [ ] **Border/frame** — optional thin border with color picker
- [ ] **Opacity control** — per-photo opacity slider
- [ ] **Rotation** — slight tilt for a "pinned photo" look
- [ ] **Caption/label** — optional text overlay below photo

### v1.3 — Layouts & Grids
- [ ] **Custom grids** — define a grid layout, place multiple photos in a grid
- [ ] **Collage mode** — arrange photos in a collage with auto-layout
- [ ] **Group photos** — group multiple photos, move/resize as a unit
- [ ] **Alignment guides** — smart guides when dragging near other photos
- [ ] **Templates** — preset layouts (2x2 grid, filmstrip, scattered, etc.)

### v1.4 — Albums & Slideshow
- [ ] **Photo albums** — group photos, cycle through them on a timer
- [ ] **Slideshow widget** — auto-rotate photos with configurable interval
- [ ] **Photos.app integration** — import directly from Photos library
- [ ] **Folder watching** — point to a folder, auto-update when photos change

### v1.5 — Advanced
- [ ] **Animated GIF support** — display animated GIFs on desktop
- [ ] **Video widget** — loop a short video clip as a desktop widget
- [ ] **URL image** — fetch and display an image from a URL (auto-refresh)
- [ ] **Calendar photo** — show a different photo for each day/month
- [ ] **Widgets for other content** — text notes, clocks, weather (stretch goal)

### App Store
- [ ] **Sandbox compliance** — add required entitlements
- [ ] **Privacy manifest** — add NSPrivacyAccessedAPITypes
- [ ] **App Store screenshots** — marketing materials
- [ ] **Notarization** — for direct distribution outside App Store

---

## Architecture

```
Sources/App/
├── PhotoWidgetOSXApp.swift    # App entry — menu bar + settings window
├── ContentView.swift          # Settings UI — photo list with controls
├── MenuBarView.swift          # Menu bar dropdown
├── DesktopPhotoWindow.swift   # Borderless NSWindow + drag/resize logic
├── PhotoItem.swift            # Data model (Codable)
├── ImageManager.swift         # PhotoManager — multi-photo orchestration
└── Assets.xcassets/           # App icon, accent color
```

**Data storage:**
- Photos: `~/Library/Application Support/PhotoWidget/*.jpg`
- State: `~/Library/Application Support/PhotoWidget/photos.json`
- Preferences: `UserDefaults` (launch at login, menu bar visibility)
