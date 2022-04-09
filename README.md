# [ChromeOS (brunch)](https://github.com/sebanc/brunch) on the Toshiba Encore 2 [[WT8-B](https://www.toshiba.ca/productdetailpage.aspx?id=2147499291)/[WT10-A](https://support.dynabook.com/support/staticContentDetail?contentId=4012954)]

Please consider [donating](https://paypal.me/djouija) to support this project. Thanks!

----------------------------------------------------------------------------------

## Preface

ChromeOS (brunch) has similar issues with the **rtl8723bs** driver as Android-x86 does, with intermittant connection issues and problems with [re]connecting to wireless networks.

I've managed to sucessfully rebuild the [linux] kernels used by brucnh [youling257's modified rockchip_wlan driver](https://github.com/youling257/rockchip_wlan), which provides a much more stable driver.

I also patched the 4.19 kernel to include PWM_LPSS (brightness/backlight) support for the Toshbia Toshiba Encore 2 [WT8-B].

Note:  The build instructoins for brunch aren't exactly fool-proof and I was experiencing a multitude of errors when trying to build a complete image, so I ended up modifying the build script to simply compile the kernel drivers, and then wrote another script to replace these directly to a USB flashed with the chromeos img.

This is still a work in progress and is not currently intended to be a guide for the time being until I have time to update this repo with more detailed information.
