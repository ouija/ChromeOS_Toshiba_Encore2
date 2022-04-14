# [ChromeOS (brunch)](https://github.com/sebanc/brunch) on the Toshiba Encore 2 [[WT8-B](https://www.toshiba.ca/productdetailpage.aspx?id=2147499291)]

Please consider [donating](https://paypal.me/djouija) to support this project. Thanks!

----------------------------------------------------------------------------------

## Preface

ChromeOS (brunch) has similar issues with the **rtl8723bs** driver as Android-x86 does, with intermittant connection issues and problems with [re]connecting to wireless networks.

I've managed to successfully rebuild the [linux] kernels used by brucnh [youling257's modified rockchip_wlan driver](https://github.com/youling257/rockchip_wlan), which provides a much more stable driver.

I also patched the 4.19 kernel to include PWM_LPSS (brightness/backlight) support for the Toshiba Encore 2 [WT8-B].

Note:  The [build instructions](https://github.com/sebanc/brunch/blob/master/BUILDING.md) for brunch aren't exactly clear or fool-proof and I was experiencing a multitude of errors when trying to build a complete image, so I ended up modifying the build script to simply compile the kernel drivers, and then wrote another script to replace these directly to a USB flashed with the chromeos img.

This is still a work in progress and is not currently intended to be a guide for the time being until I have time to update this repo with more detailed information.


## Build Kernels

_-----  Realtek rtl8723bs (rockchip_wlan) builds with brunch r100 / rammus recovery 99:_

Note you have to edit the `Makefile` for the rtl8723bs driver and hardcode the full path to the folder of the source code or build will fail;  There are some entries at the beginning of this file, and another around line 244.


**Building 4.19 rtl8723bs driver** involved using OLDER rockchip version as per [this thread](https://groups.google.com/g/android-x86/c/iwSFhlLyW7A/m/mKz0Th1JCAAJ):
```
git fetch https://github.com/youling257/rockchip_wlan v5.2.17.1
git checkout FETCH_HEAD
git reset --hard 443ce25ea0bb8e0b116e31541e534ac550be5dc8
```
also applied `drm-i915-Disable-preemption-and-sleeping-while-using-the-punit-sideband.diff` patch
also applied custom ouija backlight lpss patch to enable brightness slider.
`patch -p1 -i ../ouija-k419-brunch-i915-drm-pwm-lpss-fix.diff`
_[config file has 3 options already set]_


**Building 5.4 rtl8723bs driver** involved checking out the LATEST commit and then actually creating a [patch](https://github.com/ouija/ChromeOS_Toshiba_Encore2/blob/main/patches/kernel-54-rtl8723bs-revert-proc_ops.diff) to revert the [changes made between commit af0df86 and 443ce25](https://github.com/youling257/rockchip_wlan/commit/af0df860505dfdc5834068bf3c8e5253efec6bbe) 
 by running `git diff af0df86..443ce25 > kernel-54-rtl8723bs-revert-proc_ops.diff` and applying that to the file:
`patch rtl8723bs/os_dep/linux/rtw_proc.c patch.diff`
 

**Building 5.10 rtl8723bs driver** required checking out the LATEST commit and editing drivers/net/wireless/realtek/rtl8723bs/os_dep/linux/rtw_proc.c
and replacing all occurrences of `pde_data` with `PDE_DATA`


**Building 5.15 rtl8723bs driver** required same as v5.10

No modifications made to other kernels / not used _(chromebook-4.4, chromebook-5.4, macbook)_

To build kernels, follow the [build instructions](https://github.com/sebanc/brunch/blob/master/BUILDING.md) by checking out the brunch source:
`git clone https://github.com/sebanc/brunch.git -b r100 .`

Then make edits to each kernel version _(as per notes above)_, and then you need to compile the source for each kernel, by going into each kernel version directory and running the `make` command to first build kernel config file, then build kernel:
```
cd brunch/kernels/4.19
make -j$(nproc) O=out chromeos_defconfig
make -j$(nproc) O=out
cd ../brunch/kernels/5.4
make -j$(nproc) O=out chromeos_defconfig
make -j$(nproc) O=out
...etc..
```
Then copy the `build-kernel.sh` script from this repo to the source folder where you checked out the brunch source and run it to build all of the kernels and modules needed for Brunch/ChromeOS _(note this script is current defined to build sources for kernels 4.19, 5.4, 5.10 and 5.15)_

This should output the built kernels to the `./chroot/` directory

Then you need to have a [USB created](https://github.com/sebanc/brunch/blob/master/install-with-windows.md#usb-installations) using the same revision as the brunch source code you checked out, and then you can copy the `replace-kernels.sh` script to this `./chroot` folder where the kernel sources were built, and run it.

The `replace-kernels.sh` script should detect the `ROOT-C` partition of the Brunch/ChromeOS USB and ask you if you want to replace the default kernels with the custom ones you just built -- type `yes` and it will do so.

Then you should eject the USB and run in on the Toshiba Encore 2 [WT8-B] -- boot from the USB device, and simply run ChromeOS _(don't choose the 'options' during initial boot)_;  Brunch should load and state that RootFS is being rebuilt, and eventually ChromeOS should load.

Connect to wireless network, and accept ChromeOS agreement, and _after_ ChromeOS looks for updates, it will ask if you if you want to configure the device for You or a child.   At this screen, select `Guest Mode` at the bottom of the screen, and ChromeOS will open to a Chrome browser tab.   

Next, open the ChromeOS settings by clicking on the clock icon in the lower right corner of the taskbar and selecting the cog/gear icon, then navigate to `Power` and change `On Battery` to `Keep screen on` _(otherwise device will sleep during installation)_

Now press `CTRL-ALT-T` to open crosh, and then type in `shell`, which will open the shell, and then type in the command `sudo chromeos-install -dst /dev/mmcplk1` to install ChromeOS to the device's internal storage.   **Note that this will wipe the entire device!**

Once the installation has completed, you can reboot the device by typing `sudo reboot` into the shell, and then eject the USB, and ChromeOS should now boot from the internal storage.   You can also now choose the run the `options` menu at startup and use a different kernel;   I've been using k5.15 on this device, becaue later kernels provide better support for Baytrail devices, but I'm still determining which kernel version works best with this device.
