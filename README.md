# Photo Widget OSX

> Place any photo on your macOS desktop as a perfectly fitted, borderless widget — exactly the right aspect ratio, no cropping, no black bars.

<p align="center">
  <img src="assets/demo.gif" alt="Photo Widget OSX Action Demo" width="100%" />
</p>

![macOS](https://img.shields.io/badge/macOS-14.0+-black?style=flat-square&logo=apple) ![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=flat-square&logo=swift) ![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square) ![Version](https://img.shields.io/badge/Version-1.1.0-green?style=flat-square)

## What is this?

Photo Widget OSX is a lightweight macOS menu bar app that places photos directly on your desktop as **borderless, always-on-desktop overlays** that perfectly match each image's native aspect ratio.

Unlike Apple's built-in WidgetKit widgets (which lock you to 4 fixed sizes and crop your images), Photo Widget OSX creates a custom-sized window for each photo — so a 16:9 landscape stays 16:9, a 3:4 portrait stays 3:4, and a panorama stays a panorama.

## Download

**[⬇️ Download latest release](https://github.com/yashashwi-s/PhotoWidgetOSX/releases/latest)**

## Installation

Since Photo Widget OSX is free and open source (not distributed through the App Store), macOS Gatekeeper will show a security warning on first launch. This is normal for any app downloaded outside the App Store.

### Method 1: Right-click to Open (easiest)

1. Download and unzip `PhotoWidgetOSX.zip` from the [latest release](https://github.com/yashashwi-s/PhotoWidgetOSX/releases/latest)
2. Drag `Photo Widget OSX.app` to your **Applications** folder
3. **Right-click** (or Control-click) the app → click **Open**
4. Click **Open** again in the dialog that appears
5. You only need to do this once — after that it opens normally

### Method 2: Terminal (one command)

If right-click doesn't work, open Terminal and run:
```bash
xattr -cr /Applications/Photo\ Widget\ OSX.app
```
Then double-click the app to open it normally.

### Method 3: System Settings

1. Try to open the app normally (it will be blocked)
2. Go to **System Settings → Privacy & Security**
3. Scroll down — you'll see a message about Photo Widget OSX being blocked
4. Click **Open Anyway**

> **Why does this happen?** Apple charges $99/year for a Developer ID certificate to sign apps. Since Photo Widget OSX is free and open source, we use ad-hoc signing instead. The app is fully open source — you can audit every line of code and [build it yourself](#building-from-source) if you prefer.

## Quick Start

1. Launch the app — a 📷 icon appears in your **menu bar**
2. Click **Add Photo…** to pick images from Finder, **Add Folder…** for a rotating set, or **Photos** to pick from your Photos library
3. Your photos appear on your desktop — **drag them anywhere**
4. **Right-click** any photo to lock its position or remove it
5. **Drag corners** to resize (aspect ratio is always maintained)
6. **Scroll** on a photo to adjust its opacity
7. Click **Settings…** in the menu to customize each photo individually

## Features

### Core
- 🖼️ **Any aspect ratio** — no cropping, no black bars, ever
- 📌 **Multiple photos** — add as many as you want, each independent
- 🔒 **Lock position** — right-click photo or use menu bar to lock/unlock
- ↔️ **Corner resize** — drag any corner to resize (aspect ratio locked)
- 💾 **Remembers everything** — photos, positions, sizes, settings all persist
- 🪶 **Ultra lightweight** — ~20MB RAM, zero CPU when idle

### Floating Mode
- 🪟 **Float above windows** — turn any photo into a floating reference (above all windows)
- 👆 **Click-through** — photos pass mouse events through so they never steal focus
- ⌥ **Option key override** — hold Option to interact with a click-through photo
- 🎚️ **Per-photo opacity** — scroll wheel on any photo to adjust (10%–100%)

### Smart Canvas (Folders)
- 📁 **Folder import** — point a widget at any folder, only images are used
- 🔄 **Rotation** — on click, 30s, 5m, hourly, daily, or custom interval
- 🖱️ **Double-click to advance** — double-click any folder photo to go to the next image
- 📐 **Per-image position & size** — each image in a folder remembers its own layout independently
- ✨ **GPU crossfade** — smooth Core Animation transition between images

### Aesthetics (Per Photo)
- 🎨 **Corner radius** — 0px (sharp) to 50px (pill)
- 🌑 **Shadow** — toggle + blur/opacity controls
- 🖼️ **Border** — adjustable width with color picker
- 🌫️ **Edge fade** — subtle vignette that blends into your wallpaper

### App Shell
- 🚀 **Launch at Login** — starts automatically with your Mac
- 📱 **Photos.app integration** — pick directly from your Photos library (up to 20 at once)
- 🔽 **Hide menu bar icon** — reopen from Spotlight to restore
- 🔄 **Live menu sync** — menu bar always reflects current state

## Why not the App Store?

Apple's WidgetKit (what powers desktop widgets) only supports 4 fixed sizes. Photo Widget OSX bypasses this entirely using borderless desktop windows — which Apple's sandboxing rules don't allow on the App Store. So we're free and open source instead.

## Competitive Landscape

| App | Custom Ratio | Floating | Per-Photo Controls | Free | Method |
|-----|:---:|:---:|:---:|:---:|--------|
| **Photo Widget OSX** | ✅ Any ratio | ✅ | ✅ Full suite | ✅ Free & OSS | Desktop overlay |
| Apple Photos Widget | ❌ 4 fixed sizes | ❌ | ❌ None | ✅ Built-in | WidgetKit |
| WidgetWall | ❌ Fixed sizes | ❌ | ❌ None | Freemium | WidgetKit |
| Color Widgets | ❌ Fixed sizes | ❌ | ⚠️ Limited | ~$5 | WidgetKit |
| Superlayer | ⚠️ Limited | ✅ | ⚠️ Limited | 💰 Paid sub | Desktop overlay |

## System Requirements

- macOS 14.0 Sonoma or later
- Apple Silicon or Intel Mac

## Building from Source

```bash
# Install XcodeGen
brew install xcodegen

# Clone the repo
git clone https://github.com/yashashwi-s/PhotoWidgetOSX.git
cd PhotoWidgetOSX

# Generate Xcode project
xcodegen generate

# Open in Xcode and hit ⌘R
open PhotoWidgetOSX.xcodeproj
```

## License

MIT — use it, fork it, do whatever you want.

## Roadmap

See [FEATURES.md](FEATURES.md) for the full roadmap through v1.8, including multi-monitor support, keyboard shortcuts, grid builder, smart wallpaper integration, and scriptable desktop.
