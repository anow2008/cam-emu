#!/bin/sh
# anow2008 - Enigma2 GitHub Installer Script

URL_TAR_GZ="https://raw.githubusercontent.com/anow2008/cam-emu/main/oscam/oscam.tar.gz"
ARCHIVE_PATH="/tmp/oscam.tar.gz"
EXTRACT_DIR="/tmp/extracted_oscam"

cleanup() {
    rm -f "$ARCHIVE_PATH"
    rm -rf "$EXTRACT_DIR"
}

# تنظيف أي بقايا قديمة
cleanup

echo "====== [1/4] Downloading oscam.tar.gz from GitHub ======"
wget --no-check-certificate "$URL_TAR_GZ" -O "$ARCHIVE_PATH" 2>/dev/null || \
curl -k -L -o "$ARCHIVE_PATH" "$URL_TAR_GZ"

if [ ! -s "$ARCHIVE_PATH" ]; then
    echo "❌ Error: Failed to download oscam.tar.gz from GitHub!"
    cleanup
    exit 1
fi

echo "====== [2/4] Extracting Archive ======"
mkdir -p "$EXTRACT_DIR"
if ! tar -xzf "$ARCHIVE_PATH" -C "$EXTRACT_DIR"; then
    echo "❌ Error: Failed to extract $ARCHIVE_PATH"
    cleanup
    exit 1
fi

echo "====== [3/4] Installing IPK File(s) ======"
opkg update || echo "⚠️ Warning: opkg update failed, continuing..."

IPK_FILES=$(find "$EXTRACT_DIR" -type f -name "*.ipk")

if [ -z "$IPK_FILES" ]; then
    echo "❌ Error: No .ipk file found inside the archive!"
    cleanup
    exit 1
fi

for f in $IPK_FILES; do
    echo "Installing: $f"
    if ! opkg install --force-reinstall "$f"; then
        echo "❌ Error: Failed to install $f"
        cleanup
        exit 1
    fi
done

echo "====== [4/4] Cleaning Up ======"
cleanup

echo "✅ Done! OSCam installation completed successfully."
exit 0
