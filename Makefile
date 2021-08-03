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
	cp `realpath build.config` build.config_coresight
	cp private/msm-google/drivers/hwtracing/coresight/coresight-etm4x.c coresight-etm4x.c
	source ./sourceme ; build/build.sh |& tee comp.log

test:
	adb reboot bootloader
	sleep 1
	cd out/android-msm-pixel-4.9/private/msm-google/arch/arm64/boot ; fastboot boot Image.lz4-dtb

debug:
	fdtdump out/android-msm-pixel-4.9/private/msm-google/arch/arm64/boot/dts/qcom/sdm845-v2.dtb > dts-v2.log
	fdtdump out/android-msm-pixel-4.9/private/msm-google/arch/arm64/boot/dts/qcom/sdm845-v2.1.dtb > dts-v2.1.log

build-tools:
	git clone https://android.googlesource.com/kernel/prebuilts/build-tools

se_policy:
	adb shell getenforce
ndk:
	wget https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip
	unzip android-ndk-r21e-linux-x86_64.zip

perf_clean:
	cd perf/tools/perf ; export ARCH=arm64 ; make clean ARCH=arm64 CROSS_COMPILE=${NDK_TOOLCHAIN} CC=clang CFLAGS="--sysroot=${NDK_SYSROOT}" LLVM=1
perf_comp:
	cd perf/tools/perf ; export ARCH=arm64 ; export CROSS_COMPILE=${NDK_TOOLCHAIN}; make CC=clang CFLAGS="--sysroot=${NDK_SYSROOT}"

perf_source:
	wget https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/snapshot/linux-5.10.55.tar.gz
	tar zxvf linux-5.10.55.tar.gz
	ln -s linux-5.10.55 perf
