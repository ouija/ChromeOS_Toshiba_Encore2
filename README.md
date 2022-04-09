# [ChromeOS (brunch)](https://github.com/sebanc/brunch) on the Toshiba Encore 2 [[WT8-B](https://www.toshiba.ca/productdetailpage.aspx?id=2147499291)/[WT10-A](https://support.dynabook.com/support/staticContentDetail?contentId=4012954)]

Please consider [donating](https://paypal.me/djouija) to support this project. Thanks!

----------------------------------------------------------------------------------

## Preface

ChromeOS (brunch) has similar issues with the **rtl8723bs** driver as Android-x86 does, with intermittant connection issues and problems with [re]connecting to wireless networks.

I've managed to sucessfully rebuild the [linux] kernels used by brucnh [youling257's modified rockchip_wlan driver](https://github.com/youling257/rockchip_wlan), which provides a much more stable driver.

I also patched the 4.19 kernel to include PWM_LPSS (brightness/backlight) support for the Toshbia Toshiba Encore 2 [WT8-B].

Note:  The build instructoins for brunch aren't exactly fool-proof and I was experiencing a multitude of errors when trying to build a complete image, so I ended up modifying the build script to simply compile the kernel drivers, and then wrote another script to replace these directly to a USB flashed with the chromeos img.

This is still a work in progress and is not currently intended to be a guide for the time being until I have time to update this repo with more detailed information.


## Build Kernels

-----  RTL8723BS builds with brunch r100:


Building 4.19 rtl8723bs driver involved using OLDER rockchip version as per [this thread](https://groups.google.com/g/android-x86/c/iwSFhlLyW7A/m/mKz0Th1JCAAJ):
```
git fetch https://github.com/youling257/rockchip_wlan v5.2.17.1
git checkout FETCH_HEAD
git reset --hard 443ce25ea0bb8e0b116e31541e534ac550be5dc8
```
also applied `drm-i915-Disable-preemption-and-sleeping-while-using-the-punit-sideband.diff` patch
also applied custom ouija backlight lpss patch to enable brightness slider.
`patch -p1 -i ../ouija-k419-brunch-i915-drm-pwm-lpss-fix.diff`
_[config file has 3 options already set]_


Building 5.4 rtl8723bs driver involved checking out the LATEST commit and then actually creating a patch to revert the changes made with commit af0df86
(https://github.com/youling257/rockchip_wlan/commit/af0df860505dfdc5834068bf3c8e5253efec6bbe)
by running `git diff af0df86..443ce25 > patch.diff` and applying that to the file:
`patch rtl8723bs/os_dep/linux/rtw_proc.c patch.diff`
 

Building 5.10 rtl8723bs (latest ver) driver required editing drivers/net/wireless/realtek/rtl8723bs/os_dep/linux/rtw_proc.c
and replacing all occurrences of `pde_data` with `PDE_DATA`


Building 5.15 rtl8723bs driver works with patches made per v5.10

No modifications made to other kernels / not used _(chromebook-4.4, chromebook-5.4, macbook)_
