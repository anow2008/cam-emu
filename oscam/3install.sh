#!/bin/sh

URL="https://raw.githubusercontent.com/anow2008/cam-emu/main/oscam/enigma2-plugin-softcams-oscam-emu-pcsc-levi45_11968-803_all.ipk"
FILE="/tmp/oscam-emu.ipk"

echo "جاري التحميل..."
rm -f "$FILE"

# محاولة التحميل باستخدام wget أو curl
wget --no-check-certificate -O "$FILE" "$URL" || curl -k -L -o "$FILE" "$URL"

# التأكد من أن الملف قد تم تحميله بنجاح
if [ ! -s "$FILE" ]; then
    echo "فشل التحميل"
    exit 1
fi

echo "جاري التثبيت..."
opkg install --force-reinstall "$FILE"

rm -f "$FILE"
echo "تم التثبيت بنجاح. يرجى إعادة تشغيل واجهة المستخدم عبر الأمر:"
echo "init 4 && init 3"
