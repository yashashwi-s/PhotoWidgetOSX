#!/bin/bash
# build.sh — Build and ad-hoc sign Photo Widget OSX for distribution
# Usage: ./build.sh

set -euo pipefail

APP_NAME="Photo Widget OSX"
SCHEME="PhotoWidgetOSX"
BUILD_DIR="build"
OUTPUT_DIR="dist"

echo "🔧 Generating Xcode project..."
xcodegen generate

echo "🏗️  Building..."
xcodebuild \
  -scheme "$SCHEME" \
  -configuration Release \
  -derivedDataPath "$BUILD_DIR" \
  -arch arm64 -arch x86_64 \
  ONLY_ACTIVE_ARCH=NO \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGN_STYLE=Manual \
  DEVELOPMENT_TEAM="" \
  build 2>&1 | tail -5

# Find the built .app
APP_PATH=$(find "$BUILD_DIR" -name "$APP_NAME.app" -type d | head -1)

if [ -z "$APP_PATH" ]; then
  echo "❌ Build failed — .app not found"
  exit 1
fi

echo "✅ Built: $APP_PATH"

# Ad-hoc codesign (deep)
echo "🔏 Ad-hoc codesigning..."
codesign --force --deep --sign - "$APP_PATH"

# Strip quarantine attribute
xattr -cr "$APP_PATH"

# Copy to dist/
mkdir -p "$OUTPUT_DIR"
rm -rf "$OUTPUT_DIR/$APP_NAME.app"
cp -R "$APP_PATH" "$OUTPUT_DIR/$APP_NAME.app"

echo "📦 Creating zip for distribution..."
cd "$OUTPUT_DIR"
rm -f PhotoWidgetOSX.zip
ditto -c -k --sequesterRsrc --keepParent "$APP_NAME.app" PhotoWidgetOSX.zip
cd ..

echo ""
echo "✅ Done!"
echo "   App:  $OUTPUT_DIR/$APP_NAME.app"
echo "   Zip:  $OUTPUT_DIR/PhotoWidgetOSX.zip"
echo ""
echo "Upload PhotoWidgetOSX.zip to GitHub Releases."
