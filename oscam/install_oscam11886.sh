#!/bin/sh

# =====================================================================================================================
# SCRIPT : DOWNLOAD AND INSTALL OSCam EMU 11886
# =====================================================================================================================
# Command: wget -q "--no-check-certificate" https://raw.githubusercontent.com/anow2008/cam-emu/main/oscam/install_oscam11886.sh -O - | /bin/sh
# =====================================================================================================================

########################################################################################################################
# Plugin Settings
########################################################################################################################

PACKAGE_DIR='cam-emu/main/oscam'
MY_IPK="enigma2-plugin-softcams-oscam_11886-emu-r803_all.ipk"
# ملاحظة: إذا قمت برفع نسخة .deb للدريم بوكس لاحقاً ضع اسمها هنا
MY_DEB="enigma2-plugin-softcams-oscam_11886-emu-r803_all.deb" 

########################################################################################################################
# Auto Logic
########################################################################################################################

MY_MAIN_URL="https://raw.githubusercontent.com/anow2008/"

# تحديد نوع الحزمة بناءً على نظام الجهاز (IPK أو DEB)
if which dpkg > /dev/null 2>&1; then
    MY_FILE=$MY_DEB
    MY_URL=$MY_MAIN_URL$PACKAGE_DIR'/'$MY_DEB
else
    MY_FILE=$MY_IPK
    MY_URL=$MY_MAIN_URL$PACKAGE_DIR'/'$MY_IPK
fi

MY_TMP_FILE="/tmp/"$MY_FILE

echo ''
echo '************************************************************'
echo '** STARTED OSCAM INSTALLATION              **'
echo '************************************************************'
echo "** Uploaded by: anow2008                     **"
echo "** https://github.com/anow2008/cam-emu             **"
echo "************************************************************"
echo ''

# حذف أي ملفات قديمة من المجلد المؤقت
rm -f $MY_TMP_FILE > /dev/null 2>&1

# تحميل الملف
MY_SEP='============================================================='
echo $MY_SEP
echo "Downloading $MY_FILE ..."
echo $MY_SEP
echo ''

wget --no-check-certificate -T 5 $MY_URL -P "/tmp/"

# التحقق من نجاح التحميل
if [ -f $MY_TMP_FILE ]; then
    echo ''
    echo $MY_SEP
    echo 'Installation started'
    echo $MY_SEP
    echo ''
    
    # التثبيت بناءً على نوع الحزمة
    if which dpkg > /dev/null 2>&1; then
        dpkg -i --force-overwrite $MY_TMP_FILE
    else
        opkg install --force-reinstall $MY_TMP_FILE
    fi
    
    MY_RESULT=$?

    # التحقق من نتيجة التثبيت
    echo ''
    if [ $MY_RESULT -eq 0 ]; then
        echo "    >>>>   SUCCESSFULLY INSTALLED   <<<<"
        echo ''
        echo "    >>>>       RESTARTING GUI       <<<<"
        
        # حذف الملف بعد التثبيت
        rm -f $MY_TMP_FILE
        
        # إعادة تشغيل الإنجيما لتفعيل التغييرات
        if which systemctl > /dev/null 2>&1; then
            sleep 2; systemctl restart enigma2
        else
            init 4; sleep 4; init 3;
        fi
    else
        echo "    >>>>   INSTALLATION FAILED !   <<<<"
        rm -f $MY_TMP_FILE
    fi
    
    echo ''
    echo '**************************************************'
    echo '** FINISHED                   **'
    echo '**************************************************'
    echo ''
    exit 0
else
    echo ''
    echo "Download failed! Please check your internet connection."
    exit 1
fi
