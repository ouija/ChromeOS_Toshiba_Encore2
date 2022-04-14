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

* Replace staging driver for `rtl8723bs` with [youling257 driver](https://github.com/youling257/rockchip_wlan):
	* Clone the latest branch of youling257's driver via `git clone https://github.com/youling257/rockchip_wlan.git`
	* Move the `rtl8723bs` folder to `./<kernel>/drivers/net/wireless/realtek/`
	* Add references for this to the `./<kernel>/drivers/net/wireless/realtek/Makefile` and `./kernel/drivers/net/wireless/realtek/Kconfig` files:
		* In **Kconfig** add `source "drivers/net/wireless/realtek/rtl8723bs/Kconfig"`
		* In **Makefile** add `obj-$(CONFIG_RTL8723BS) += rtl8723bs/`
	* Modify `./<kernel>/drivers/net/wireless/realtek/rtl8723bs/Makefile` to avoid issues with include paths during source compile:
	* Delete/replace **line 24**:  `EXTRA_CFLAGS += -I$(src)/include`  with the following three new lines:
	    ```
	    EXTRA_CFLAGS += -I/<path to>/<kernel>/drivers/net/wireless/realtek/rtl8723bs/include
	    EXTRA_CFLAGS += -I/<path to>/<kernel>/drivers/net/wireless/realtek/rtl8723bs/hal/phydm
	    EXTRA_CFLAGS += -I/<path to>/<kernel>/drivers/net/wireless/realtek/rtl8723bs/platform
	    ```
	* Modify the values above after `EXTRA_CFLAGS += -I/` with the full path to your Android-x86 source files!
	* Then replace **line 156** *(now line 158 after completing the above edit)* from this: 
	    `export TopDIR ?= $(shell pwd)`
	* To instead be:
	    `export TopDIR ?= /<path to>/<kernel>/drivers/net/wireless/realtek/rtl8723bs/`
	* And again modify this line above with the full path to your Android-x86 source files!
	* Remove inclusion of the original driver by deleting the references to `rtl8723bs` from `Kconfig` and `Makefile` files in `<kernel>/driver/staging` folder


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

To build kernels, follow the [build instructions](https://github.com/sebanc/brunch/blob/master/BUILDING.md) by checking out the brunch source, ie:
`git clone https://github.com/sebanc/brunch.git -b r100`

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
Then copy the [build-kernel.sh](https://github.com/ouija/ChromeOS_Toshiba_Encore2/blob/main/build-kernel.sh) script from this repo to the source folder where you checked out the brunch source and run it to build all of the kernels and modules needed for Brunch/ChromeOS _(note this script is current defined to build sources for kernels 4.19, 5.4, 5.10 and 5.15)_

This should output the built kernels to the `./chroot/` directory

Then you need to have a [USB created](https://github.com/sebanc/brunch/blob/master/install-with-windows.md#usb-installations) using the same revision as the brunch source code you checked out, and then you can copy the [replace-kernel.sh](https://github.com/ouija/ChromeOS_Toshiba_Encore2/blob/main/replace_kernel.sh) script to this `./chroot` folder where the kernel sources were built, and run it.

The [replace-kernel.sh](https://github.com/ouija/ChromeOS_Toshiba_Encore2/blob/main/replace_kernel.sh) script should detect the `ROOT-C` partition of the Brunch/ChromeOS USB and ask you if you want to replace the default kernels with the custom ones you just built -- type `yes` and it will do so.

Then you should eject the USB and run in on the Toshiba Encore 2 [WT8-B] -- boot from the USB device, and simply run ChromeOS _(don't choose the 'options' during initial boot)_;  Brunch should load and state that RootFS is being rebuilt, and eventually ChromeOS should load.

Connect to wireless network, and accept ChromeOS agreement, and _after_ ChromeOS looks for updates, it will ask `Who's using this Chromebook?`.  At this screen, select `Browse as Guest` at the bottom of the screen, and ChromeOS will open to a Chrome browser tab.   

Next, open the ChromeOS settings by clicking on the clock icon in the lower right corner of the taskbar and selecting the cog/gear icon at the top of the menu that pops up to open the settings menu, then under the `Device` section click on `Power` and change the `When idle` for `While on battery` to `Keep display on` _(otherwise device will sleep during installation)_ and click the 'x' icon in the top right of the settings window to close it

Now you should be on the Chrome window/tab that says `You're browsing as a Guest` and press `CTRL-ALT-T` to open crosh, and then type in `shell`, which will open the shell, and then type in the command `sudo chromeos-install -dst /dev/mmcblk1` to install ChromeOS to the device's internal storage.   **Note that this will wipe the entire device!**

_Note that there may be issues booting the device after installation;  I had an EFI partition already created on my device with the [efi folder](https://github.com/ouija/ChromeOS_Toshiba_Encore2/blob/main/efi.zip) taken from the ChromeOS installer, and I believe that the `chromeos-install` script didn't modify this partition, so just making note of this here.  Also note that changing brunch options via USB (prior to install) seemed to cause ChromeOS to fail to boot (from usb), but not if you installed to internal storage and changed options from there_  

Once the installation has completed, you can reboot the device by typing `sudo reboot` into the shell, and then eject the USB, and ChromeOS should now boot from the internal storage.   You can also now choose the run the `options` menu at startup and use a different kernel;   I've been using k5.15 on this device, becaue later kernels provide better support for Baytrail devices, but I'm still determining which kernel version works best with this device.
