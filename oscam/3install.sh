#!/bin/sh

URL="https://github.com/anow2008/cam-emu/raw/main/oscam/enigma2-plugin-softcams-oscam-emu-pcsc-levi45_11968-803_all.ipk"
FILE="/tmp/oscam-emu.ipk"

echo "جاري التحميل..."
rm -f "$FILE"

# جرّب wget الأول، ولو مش شغال استخدم curl
wget --no-check-certificate -O "$FILE" "$URL" || curl -k -L -o "$FILE" "$URL"

# تأكد إن الملف اتحمل
if [ ! -s "$FILE" ]; then
    echo "فشل التحميل"
    exit 1
fi

echo "جاري التثبيت..."
opkg install --force-reinstall "$FILE"

rm -f "$FILE"
echo "تم. اعمل ريستارت للـ GUI:"
echo "init 4 && init 3"
