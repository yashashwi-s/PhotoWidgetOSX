# Photo Widget for macOS

> Place any photo on your desktop as a perfectly fitted, borderless widget — with the exact aspect ratio of the image. No cropping. No black bars. Just your photo.

![macOS](https://img.shields.io/badge/macOS-14.0+-black?style=flat-square&logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=flat-square&logo=swift)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

## What is this?

Photo Widget is a lightweight macOS menu bar app that places photos directly on your desktop as **borderless, always-on-desktop overlays** that perfectly match each image's native aspect ratio.

Unlike Apple's built-in WidgetKit widgets (which are locked to fixed sizes and crop your images), Photo Widget creates a custom-sized window for each photo — so a 16:9 landscape stays 16:9, a 3:4 portrait stays 3:4, and a panorama stays a panorama.

## Why not use WidgetKit?

Apple's WidgetKit only supports 4 fixed sizes: Small, Medium, Large, and Extra Large. Your photo must fit into one of those rectangles — meaning it gets **cropped** or **padded with black bars**. Photo Widget bypasses this limitation entirely by using borderless desktop windows instead.

## Quick Start

1. **Build & Run** the project in Xcode
2. Look for the 📷 icon in your **menu bar**
3. Click **Add Photo…** and select an image
4. Your photo appears on your desktop — drag it anywhere
5. **Double-click** a photo to lock/unlock its position
6. Use the **slider** in settings to resize, or **drag corners/edges** directly

## Features

See [FEATURES.md](FEATURES.md) for a detailed breakdown.

- 🖼️ **Any aspect ratio** — your photo, your ratio
- 📌 **Multiple photos** — add as many as you want
- 🔒 **Lock position** — double-click to lock/unlock
- ↔️ **Resize from edges/corners** — corners maintain ratio, edges stretch freely
- 🚀 **Launch at Login** — starts automatically with your Mac
- 💾 **Remembers everything** — photos, positions, sizes, lock states persist across restarts
- 🪶 **Ultra lightweight** — ~20MB RAM, zero CPU when idle
- 🎨 **Rounded corners + shadow** — looks like a native widget

## System Requirements

- macOS 14.0 (Sonoma) or later
- ~20-30MB RAM per running instance

## Building from Source

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/PhotoWidgetOSX.git
cd PhotoWidgetOSX

# Generate Xcode project (requires XcodeGen)
brew install xcodegen
xcodegen generate

# Open in Xcode
open PhotoWidgetOSX.xcodeproj
```

Then select the `PhotoWidgetOSX` scheme and hit **⌘R** to build and run.

## Competitive Landscape

| App | Custom Ratio? | Free? | Approach |
|-----|:---:|:---:|---------|
| **Photo Widget (this)** | ✅ Any | ✅ Free & open source | Desktop overlay |
| Apple Photos Widget | ❌ Fixed 4 sizes | ✅ Built-in | WidgetKit |
| WidgetWall | ❌ Fixed sizes | Freemium | WidgetKit |
| Color Widgets | ❌ Fixed sizes | Freemium ($5 Pro) | WidgetKit |
| Superlayer | ⚠️ Some flexibility | Paid subscription | Desktop overlay |
| DeskTop Photo Player | ⚠️ Resizable window | ✅ Free | Floating window |

**Our differentiator:** We're the only **free, open-source** app that creates desktop photo overlays with **automatic aspect ratio matching** and **edge/corner resize handles**.

## App Store

To publish on the Mac App Store:
- Requires an **Apple Developer Program** membership ($99/year)
- App can be listed for **free** — there's no cost to list a free app beyond the developer fee
- Must comply with App Sandbox and App Review Guidelines
- This project is App Store-ready with minor additions (sandbox entitlements, app icon)

## License

MIT License — do whatever you want with it.

## Contributing

PRs welcome! See [FEATURES.md](FEATURES.md) for the roadmap of planned features.
