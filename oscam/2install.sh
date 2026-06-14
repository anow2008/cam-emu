#!/bin/sh
# MOHAMED_OS - Enigma2 GitHub Installer Script

# --- روابط جيت هاب المباشرة (Raw Links) ---
URL_TAR_GZ="https://raw.githubusercontent.com/anow2008/cam-emu/main/oscam/oscam.tar.gz"
# -------------------------------------------

ARCHIVE_PATH="/tmp/oscam.tar.gz"
EXTRACT_DIR="/tmp/extracted_oscam"

echo "====== [1/4] Downloading oscam.tar.gz from GitHub ======"
# تحميل ملف الأرشيف
wget --no-check-certificate "$URL_TAR_GZ" -O "$ARCHIVE_PATH"

if [ $? -ne 0 ] || [ ! -s "$ARCHIVE_PATH" ]; then
    echo "❌ Error: Failed to download oscam.tar.gz from GitHub!"
    exit 1
fi

echo "====== [2/4] Extracting Archive ======"
# إنشاء الفولدر المؤقت وفك الضغط
mkdir -p "$EXTRACT_DIR"
tar -xzf "$ARCHIVE_PATH" -C "$EXTRACT_DIR"

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to extract $ARCHIVE_PATH"
    rm -f "$ARCHIVE_PATH"
    rm -rf "$EXTRACT_DIR"
    exit 1
fi

echo "====== [3/4] Installing IPK File(s) ======"
# تحديث الفيد لضمان التثبيت بدون نقص اعتماديات
opkg update

# التثبيت
cd "$EXTRACT_DIR"
if ls *.ipk 1> /dev/null 2>&1; then
    opkg install *.ipk
else
    echo "❌ Error: No .ipk file found inside the archive!"
    rm -f "$ARCHIVE_PATH"
    rm -rf "$EXTRACT_DIR"
    exit 1
fi

echo "====== [4/4] Cleaning Up ======"
# تنظيف مسار /tmp
rm -f "$ARCHIVE_PATH"
rm -rf "$EXTRACT_DIR"

echo "✅ Done! OSCam installation completed successfully."
exit 0
