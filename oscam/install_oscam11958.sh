#!/bin/sh

# =====================================================================================================================
# SCRIPT : DOWNLOAD AND INSTALL Oscam_EMU 11958
# =====================================================================================================================
# Developed/Modified by: Mohamed
# File Name: install_oscam11958.sh
# =====================================================================================================================

########################################################################################################################
# Plugin Configuration
########################################################################################################################

# رابط الملف الخام (Raw) من مستودع anow2008
MY_URL="https://raw.githubusercontent.com/anow2008/cam-emu/main/oscam/oscam-11958-r802.ipk"
MY_FILE="oscam-11958-r802.ipk"
MY_TMP_FILE="/tmp/"$MY_FILE

########################################################################################################################
# Execution
########################################################################################################################

echo ''
echo '************************************************************'
echo '** STARTED                        **'
echo '************************************************************'
echo "** Installer: install_oscam11958           **"
echo "************************************************************"
echo ''

# حذف الملف القديم من المجلد المؤقت إذا وجد
rm -f $MY_TMP_FILE > /dev/null 2>&1

# تحميل ملف الـ IPK
MY_SEP='============================================================='
echo $MY_SEP
echo 'Downloading '$MY_FILE' ...'
echo $MY_SEP
echo ''
wget -T 10 $MY_URL -P "/tmp/"

# التحقق من وجود الملف بعد التحميل
if [ -f $MY_TMP_FILE ]; then
	echo ''
	echo $MY_SEP
	echo 'Installation started'
	echo $MY_SEP
	echo ''
	
	# تثبيت الملف باستخدام opkg (مناسب لجهاز VU+ Zero 4K وبقية أجهزة Enigma2)
	opkg install --force-reinstall $MY_TMP_FILE
	
	MY_RESULT=$?

	# عرض النتيجة وإعادة تشغيل الجهاز
	echo ''
	echo ''
	if [ $MY_RESULT -eq 0 ]; then
		echo "   >>>>   SUCCESSFULLY INSTALLED   <<<<"
		echo ''
		echo "   >>>>         RESTARTING ENIGMA2         <<<<"
		if which systemctl > /dev/null 2>&1; then
			sleep 2; systemctl restart enigma2
		else
			init 4; sleep 4; init 3;
		fi
	else
		echo "   >>>>   INSTALLATION FAILED !   <<<<"
	fi;
	
	# تنظيف المجلد المؤقت بعد التثبيت
	rm -f $MY_TMP_FILE
	
	echo ''
	echo '**************************************************'
	echo '** FINISHED                   **'
	echo '**************************************************'
	echo ''
	exit 0
else
	echo ''
	echo "Download failed! Please check the link or network connection."
	exit 1
fi
