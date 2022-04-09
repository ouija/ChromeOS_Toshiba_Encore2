#!/bin/bash
# replace brunch kernels script by ouija
clear
echo "Brunch/ChromeOS kernel replacement script by @ouija"
echo

kernels="4.19 5.4 5.10 5.15"
kernel_modules="kernel-4.19.234-brunch-sebanc.tar.gz kernel-5.4.184-brunch-sebanc.tar.gz kernel-5.10.106-brunch-sebanc.tar.gz kernel-5.15.28-brunch-sebanc.tar.gz"

for kernel in $kernels; do
    if [ ! -f "kernel-$kernel" ]; then    
        echo "kernel replacement for $kernel missing, cannot continue!"
        echo
        exit
    fi
done
for module in $kernel_modules; do
    if [ ! -f "$module" ]; then    
        echo "moudle package replacement for $module missing, cannot continue!"
        echo
        exit
    fi
done

#check if root
if [ "$(whoami)" != "root" ] ; then
    echo "Please run script as root!"
    echo
    exit
fi

# check if image mounted (usb or local image)
# parition 7 of the USB should mount as "ROOT-C" which contains kernels
usb_mnt_find=$(grep '/ROOT-C ' /proc/mounts)
usb_mnt_path=($(echo "$usb_mnt_find" | tr ' ' '\n'))

if [ ! -z "${usb_mnt_path[1]}" ]; then
    # Brunch root mount detected
    echo "Brunch/ChromeOS root partition (USB?) detected at: ${usb_mnt_path[1]}"
    read -p "Do you want to replace the kernels in brunch [root] image detected at ${usb_mnt_path[1]} with custom built ones? (yes/no) " yn
    case $yn in 
        yes ) echo "Replacing kernels, please wait..";
            # Replace kernels at detected location
            echo
            for kernel in $kernels; do
                if [ -f "${usb_mnt_path[1]}/kernel-$kernel" ]; then    
                    echo "${usb_mnt_path[1]}/kernel-$kernel found, removing.."
                    rm ${usb_mnt_path[1]}/kernel-$kernel
                fi
            done
            for module in $kernel_modules; do
                if [ -f "${usb_mnt_path[1]}/packages/$module" ]; then    
                    echo "${usb_mnt_path[1]}/packages/$module found, removing.."
                    rm ${usb_mnt_path[1]}/packages/$module
                fi
            done

            for kernel in $kernels; do
                echo "Copying custom kernel-$kernel to ${usb_mnt_path[1]}, please wait.."
                cp kernel-$kernel ${usb_mnt_path[1]}/
                chmod 644 ${usb_mnt_path[1]}/kernel-$kernel
            done
            for module in $kernel_modules; do
                echo "Copying module package $module to ${usb_mnt_path[1]}, please wait.."
                cp $module ${usb_mnt_path[1]}/packages/
                chmod 644 ${usb_mnt_path[1]}/packages/$module
            done
            echo
            echo "Kernels and module packages replaced successfully!"
            echo            
            exit;;
            #break;;
        no ) echo "No changes were made!  Exiting..";
            echo
            exit;;
        * ) echo "Invalid response; Exiting..";
            echo
            exit;;
    esac
else
    # Brunch root mount not detected, look for img
    echo "Brunch/ChromeOS root partition (USB?) NOT partition; Searching for local chromeos.img file.."
fi
exit





# while true; do

# read -p "Do you want to replace the kernels in brunch [root] image with custom built ones? (yes/no) " yn

# case $yn in 
# 	yes ) echo "Looking for mounted brunch [root] partition..";

# 		break;;
# 	no ) echo exiting...;
# 		exit;;
# 	* ) echo invalid response;;
# esac

# done

# echo doing stuff...