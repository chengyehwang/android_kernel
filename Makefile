# https://c55jeremy-tech.blogspot.com/2019/04/aospkernelaosp.html
# pixel 3
SHELL := /bin/bash
tool:
	curl https://storage.googleapis.com/git-repo-downloads/repo > repo
	chmod 755 ./repo
source:
	./repo init -u https://android.googlesource.com/kernel/manifest -b android-msm-crosshatch-4.9-android11-qpr2
	./repo sync

enable_coresight:
	echo 1
comp:
	source ./sourceme ; build/build.sh

test:
	adb reboot bootloader
	sleep 1
	cd out/android-msm-pixel-4.9/private/msm-google/arch/arm64/boot ; fastboot boot Image.lz4-dtb

build-tools:
	git clone https://android.googlesource.com/kernel/prebuilts/build-tools

