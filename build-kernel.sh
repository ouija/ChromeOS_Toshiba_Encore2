#!/bin/bash
clear
echo "Building kerneles for brunch/chromeos, please wait..."
echo

#note that the chrome links default kernel to kernel-5.4
#and kernel-chromebook-4.4 to kernel-chromebook (so no need to replace these specifically in image)
#ln -s kernel-5.4 ./chroot/home/chronos/rootc/kernel
#ln -s kernel-chromebook-4.4 ./chroot/home/chronos/rootc/kernel-chromebook

# Note I also only build normal kernels, omit chromebook macbook
#kernels="4.19 5.4 5.10 5.15 chromebook-4.4 chromebook-5.4 macbook"
kernels="4.19 5.4 5.10 5.15"

mkdir -p chroot/tmp

for kernel in $kernels; do
echo "Building kernel $kernel.."
echo

mkdir -p ./chroot/home/chronos/kernel
cp -r ./kernels/"$kernel" ./chroot/tmp/kernel
cd ./chroot/tmp/kernel
kernel_version="$(file ./out/arch/x86/boot/bzImage | cut -d' ' -f9)"
cp ./out/arch/x86/boot/bzImage ../../kernel-"$kernel"
make O=out INSTALL_MOD_PATH=../../../home/chronos/kernel modules_install
rm ../../home/chronos/kernel/lib/modules/"$kernel_version"/build
rm ../../home/chronos/kernel/lib/modules/"$kernel_version"/source
cp -r ./headers ../../home/chronos/kernel/lib/modules/"$kernel_version"/build
mkdir -p ../../home/chronos/kernel/usr/src
ln -s /lib/modules/"$kernel_version"/build ../../home/chronos/kernel/usr/src/linux-headers-"$kernel_version"
cd ../../..

if [ "$1" != "skip" ] && [ "$2" != "skip" ]; then

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ]; then

cp -r ./chroot/home/chronos/kernel/lib/modules ./chroot/home/chronos/kernel/lib/orig
cp -r ./external-drivers/backport-iwlwifi-core64 ./chroot/tmp/backport-iwlwifi
cd ./chroot/tmp/backport-iwlwifi
make defconfig-iwlwifi-public
make -j$(($(nproc)-1))
make KLIB=../../../home/chronos/kernel install
cd ../../..
rm -r ./chroot/tmp/backport-iwlwifi
rm -r ./chroot/home/chronos/kernel/lib/modules/"$kernel_version"/build
rm -r ./chroot/home/chronos/kernel/lib/modules/"$kernel_version"/kernel
mv ./chroot/home/chronos/kernel/lib/modules/"$kernel_version" ./chroot/home/chronos/kernel/lib/orig/"$kernel_version"/iwlwifi_backport
rm -r ./chroot/home/chronos/kernel/lib/modules
mv ./chroot/home/chronos/kernel/lib/orig ./chroot/home/chronos/kernel/lib/modules

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtbth ./chroot/tmp/
cd ./chroot/tmp/rtbth
make -j$(($(nproc)-1))
cp ./rtbth.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtbth.ko
cd ../../..
rm -r ./chroot/tmp/rtbth

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl8188eu ./chroot/tmp/
cd ./chroot/tmp/rtl8188eu
make -j$(($(nproc)-1)) modules
cp ./8188eu.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8188eu.ko
cd ../../..
rm -r ./chroot/tmp/rtl8188eu

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl8188fu ./chroot/tmp/
cd ./chroot/tmp/rtl8188fu
make -j$(($(nproc)-1)) modules
cp ./rtl8188fu.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8188fu.ko
cd ../../..
rm -r ./chroot/tmp/rtl8188fu

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl8192eu ./chroot/tmp/
cd ./chroot/tmp/rtl8192eu
make -j$(($(nproc)-1)) modules
cp ./8192eu.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8192eu.ko
cd ../../..
rm -r ./chroot/tmp/rtl8192eu

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl8723bu ./chroot/tmp/
cd ./chroot/tmp/rtl8723bu
make -j$(($(nproc)-1)) modules
cp ./8723bu.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8723bu.ko
cd ../../..
rm -r ./chroot/tmp/rtl8723bu

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ]; then

cp -r ./external-drivers/rtl8723de ./chroot/tmp/
cd ./chroot/tmp/rtl8723de
make -j$(($(nproc)-1))
cp ./rtl8723de.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8723de.ko
cd ../../..
rm -r ./chroot/tmp/rtl8723de

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl8723du ./chroot/tmp/
cd ./chroot/tmp/rtl8723du
make -j$(($(nproc)-1))
cp ./8723du.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8723du.ko
cd ../../..
rm -r ./chroot/tmp/rtl8723du

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl8812au ./chroot/tmp/
cd ./chroot/tmp/rtl8812au
make -j$(($(nproc)-1)) modules
cp ./8812au.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8812au.ko
cd ../../..
rm -r ./chroot/tmp/rtl8812au

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl8814au ./chroot/tmp/
cd ./chroot/tmp/rtl8814au
make -j$(($(nproc)-1)) modules
cp ./8814au.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8814au.ko
cd ../../..
rm -r ./chroot/tmp/rtl8814au

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl8821ce ./chroot/tmp/
cd ./chroot/tmp/rtl8821ce
make -j$(($(nproc)-1)) modules
cp ./8821ce.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8821ce.ko
cd ../../..
rm -r ./chroot/tmp/rtl8821ce

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl8821cu ./chroot/tmp/
cd ./chroot/tmp/rtl8821cu
make -j$(($(nproc)-1)) modules
cp ./8821cu.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8821cu.ko
cd ../../..
rm -r ./chroot/tmp/rtl8821cu

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl88x2bu ./chroot/tmp/
cd ./chroot/tmp/rtl88x2bu
make -j$(($(nproc)-1)) modules
cp ./88x2bu.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl88x2bu.ko
cd ../../..
rm -r ./chroot/tmp/rtl88x2bu

fi

if [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/rtl8852ae ./chroot/tmp/
cd ./chroot/tmp/rtl8852ae
make -j$(($(nproc)-1))
cp ./rtl8852ae.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/rtl8852ae.ko
cd ../../..
rm -r ./chroot/tmp/rtl8852ae

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/broadcom-wl ./chroot/tmp/
cd ./chroot/tmp/broadcom-wl
make -j$(($(nproc)-1))
cp ./wl.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/broadcom_wl.ko
cd ../../..
rm -r ./chroot/tmp/broadcom-wl

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/acpi_call ./chroot/tmp/
cd ./chroot/tmp/acpi_call
make -j$(($(nproc)-1))
cp ./acpi_call.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/acpi_call.ko
cd ../../..
rm -r ./chroot/tmp/acpi_call

fi

if [ "$kernel" == "4.19" ] || [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ]; then

cp -r ./external-drivers/goodix ./chroot/tmp/
cd ./chroot/tmp/goodix
make -j$(($(nproc)-1)) modules
cp ./goodix.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/goodix.ko
cd ../../..
rm -r ./chroot/tmp/goodix

fi

if [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ] || [ "$kernel" == "5.15" ]; then

cp -r ./external-drivers/ipts ./chroot/tmp/
cd ./chroot/tmp/ipts
make -j$(($(nproc)-1))
cp ./ipts.ko ../../../chroot/home/chronos/kernel/lib/rm -r ./chroot/tmp/
modules/"$kernel_version"/ipts.ko
cd ../../..
rm -r ./chroot/tmp/ipts

fi

if [ "$kernel" == "5.4" ] || [ "$kernel" == "5.10" ]; then

cd ./chroot/tmp/kernel
patch -p1 --no-backup-if-mismatch -N < ../../../external-drivers/oled/oled-"$kernel".patch
if [ "$kernel" == "5.4" ]; then cec="drivers/media/cec/cec.ko"; else cec="drivers/media/cec/core/cec.ko"; fi
make -j$(($(nproc)-1)) O=out drivers/acpi/video.ko drivers/char/agp/intel-gtt.ko drivers/gpu/drm/drm.ko drivers/gpu/drm/drm_kms_helper.ko drivers/gpu/drm/i915/i915.ko drivers/i2c/algos/i2c-algo-bit.ko "$cec"
cp ./out/drivers/gpu/drm/drm_kms_helper.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/drm_kms_helper-oled.ko
cp ./out/drivers/gpu/drm/i915/i915.ko ../../../chroot/home/chronos/kernel/lib/modules/"$kernel_version"/i915-oled.ko
cd ../../..

fi

fi

cd ./chroot/home/chronos/kernel
tar zcf ../../../kernel-"$kernel_version".tar.gz * --owner=0 --group=0
cd ../../../..
rm -r ./chroot/home/chronos/kernel
rm -r ./chroot/tmp/kernel

done

rm -r ./chroot/home/
rm -r ./chroot/tmp/
echo "DONE!    [kernels built in directory /chroot]"
echo