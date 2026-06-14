#!/bin/sh
# Enigma2 GitHub Installer Script

# --- إعدادات الروابط (عدل الروابط دي لروابط المستودع بتاعك) ---
# تنبيه: لازم تستخدم رابط الـ Raw للملف مش رابط الصفحة العادية!
URL_TAR_GZ="https://raw.githubusercontent.com/username/repo-name/main/myfile.tar.gz"
# -------------------------------------------------------------

ARCHIVE_PATH="/tmp/myfile.tar.gz"
EXTRACT_DIR="/tmp/extracted_ipk"

echo "====== [1/4] Downloading Archive from GitHub ======"
# استخدام wget لتحميل الملف مع تخطي فحص الشهادة لتجنب المشاكل
wget --no-check-certificate "$URL_TAR_GZ" -O "$ARCHIVE_PATH"

if [ $? -ne 0 ] || [ ! -s "$ARCHIVE_PATH" ]; then
    echo "❌ Error: Failed to download the file from GitHub!"
    exit 1
fi

echo "====== [2/4] Extracting tar.gz ======"
mkdir -p "$EXTRACT_DIR"
tar -xzf "$ARCHIVE_PATH" -C "$EXTRACT_DIR"

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to extract $ARCHIVE_PATH"
    rm -f "$ARCHIVE_PATH"
    rm -rf "$EXTRACT_DIR"
    exit 1
fi

echo "====== [3/4] Installing IPK File(s) ======"
opkg update

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
rm -f "$ARCHIVE_PATH"
rm -rf "$EXTRACT_DIR"

echo "✅ Done! Installation completed successfully."
exit 0
