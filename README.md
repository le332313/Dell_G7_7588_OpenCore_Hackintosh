# Dell_G7_7588_OpenCore_Hackintosh
## **Great new: I just updated a new EFI folder for upgrading to Big Sur Beta. If you are using a Broadcom wifi card, remmeber to disable AirportBrcm4360_Injector.kext and set its MaxKernel is 19.9.9. Credit [here](https://github.com/acidanthera/AirportBrcmFixup/blob/master/README.md#please-pay-attention)**
## Overview
- Lastest macOS Catalina 10.15.7
- Bootloader: OpenCore 0.6.2
- EFI folder can be used both for USB Installer and booting.
## Hardware configuration
* Dell G7 7588
  - CPU: i7-8750H
  - RAM: 16Gb 2x DDR4 (upgraded)
  - Display: 1080p
  - SSD: 
      * M.2 SATA Kingston SM2280S3G2120G 120Gb for macOS
      * 2.5 inch SATAIII Crucial CT500MX500SSD1 500Gb for Windows 10 and DATAs
  - Sound: ALC256
  - Wireless + Bluetooth: Replaced with BCM94352Z aka DW1560 ʕ •ᴥ•ʔゝ☆
  - VGA: Nvidia GTX 1050Ti (disabled)
  - BIOS: 1.14.0 (latest)
  
## Graphics
Integrated Intel UHD Graphics 630 support is handled by WhateverGreen, and configured in the `PciRoot(0x0)/Pci(0x2,0x0)` section of `config.plist`.
The Nvidia GPU is not supported so it is disabled to using `SSDT-DDGPU.aml`.
The default BIOS DVMT pre-alloc value of `64MB` is sufficient and does not need to be changed.
### Enabling acceleration
* [config.plist](https://github.com/sn0wfL4ke98/Dell_G7_7588_OpenCore_Hackintosh/blob/master/EFI/OC/config.plist)
  * `DeviceProperties/Add/PciRoot(0x0)/Pci(0x2,0x0)`
    * `AAPL,ig-platform-id = <00009b3e>`
### Enabling external display support
* [config.plist](https://github.com/sn0wfL4ke98/Dell_G7_7588_OpenCore_Hackintosh/blob/master/EFI/OC/config.plist)
  * Boot Arguments
    * `agdpmod=vit9696`
  * `DeviceProperties/Add/PciRoot(0x0)/Pci(0x2,0x0)`
    * `framebuffer-patch-enable = <01000000>`
    * `framebuffer-portcount = <04000000>`
    * `framebuffer-con1-enable = <01000000>`
    * `framebuffer-con1-alldata = <01050900 00040000 87010000>`
    * `framebuffer-con2-enable = <01000000>`
    * `framebuffer-con2-alldata = <02060900 00040000 87010000>`
    * `framebuffer-con3-enable = <01000000>`
    * `framebuffer-con3-alldata = <03040a00 00080000 87010000>`
    * `enable-hdmi20 = <01000000>`
    * `enable-lspcon-support = <01000000>`
    * `framebuffer-con3-has-lspcon = <01000000>`
    * `framebuffer-con3-preferred-lspcon-mode = <01000000>`
* credit patch: [bavariancake's XPS 9570 repo](https://github.com/bavariancake/XPS9570-macOS#enabling-external-display-support).

## Keyboard
Brightness keys are enabled using `SSDT-BRT.aml` and two patches in `Kernel/Patch`.
Also there is a rename BRT6 to BRTX in `ACPI/Patch`.
  * Comment: change BRT6 to BRTX
  * Count: 0
  * Limit: 0
  * Enable: Yes
  * Find: 14204252 543602
  * Replace: 14204252 545802

## iMessages and Facetime
Follow [this guide](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html) from Dortania.
- Make sure you have to change the ROM in `PlatformInfo/Generic/ROM`.
- Also I highly recommend you should get a new valid serial number and other SMBIOS related data for iMessage/Facetime to work. You can use [Corpnewt's GenSMBIOS](https://github.com/corpnewt/GenSMBIOS).

## Audio
- For ALC256, I use `layout-id = <21>`. This id can give you 3.5mm headphone jack (just headphone!).
- For fixing headset jack, run the `install.sh` in `ComboJack_Lastest` folder. You can use both internal and external microphone.
- credit: [Ivs1974](https://github.com/lvs1974/ComboJack)

## Thunderbolt 3
- Thunderbolt device will work in macOS when attached prior to boot, but will lose functionality when hotplugged. So make sure you have to plug it first, then power on the laptop and boot into macOS, it will work!

## Touch ID/Goodix Fingerprint Sensor
Since I'm using the `MacBookPro15,1` SMBIOS, macOS is expecting Touch ID to be available, causing lag on password prompts. So it can be disabled using `NoTouchID.kext`.

## Keyboard and Trackpad
* The keyboard is PS2, so I use `VoodooPS2Controller.kext`. But I already deleted `VoodooInput.kext` and `VoodooPS2Trackpad.kext` plugin inside because of some stupid things.
* The trackpad is from Synaptics, but is I2C device. So it can be driven with VoodooI2C, also provides basic trackpad support. For me, I use `VoodooI2C.kext` and `VoodooI2CHID.kext`.

## Sleep/Wake Enhances
Only run these commands in Terminal and done:
  ```
  sudo pmset autopoweroff 0
  sudo pmset powernap 0
  sudo pmset standby 0
  sudo pmset proximitywake 0
  ```

## System Integrity Protection (SIP)
* SIP is disabled. I hate SIP.

## HiDPI
* I recommend you should install manually. Download [Hackintool](https://github.com/headkaze/Hackintool), extract and put it to Applications
* Run it, go to Utilities tab, click ![Disable Gatekeeper](https://cdn.discordapp.com/attachments/719556350161584179/765493559649894430/unknown.png) icon. This icon means Hackintool will disable the Gatekeeper and mount the disk in read/write mode.
* When ![Success](https://cdn.discordapp.com/attachments/719556350161584179/765493356984926249/unknown.png) shows up, it means successful. Now go to `/System/Library/Displays/Contents/Resources/Overrides/`, rename the current `Icons.plist` to another name, like `IconsBackup.plist`.
* Copy `DisplayVendorID-30e4` folder and `Icons.plist` to `Overrides` folder. If everything is okay, restart your laptop to take effect.

## CFG-Unlock (Recommended but not highly recommended)
* Run `modGRUBShell.efi` at OpenCore picker.
* When `> grub` show up, type `setup_var 0x5BD 0x00` and hit Enter.
* The screen will show `setting offset 0x5bd to 0x00`, that done. Now you can change both `AppleCpuPmCfgLock` and `AppleXcpmCfgLock` in Kernel/Quirks from `True` to `False`.
* credit: [Juan-VC](https://juan-vc.github.io/oc-g7-guide/post-installation/disable-cfg-lock.html).

## Credit
* Apple for macOS
* Acidanthera team
* Dortania team
* Rehabman
* Ivs1974 for ComboJack Fix
* Juan-VC for CFG-Unlock

## Support
* Support me to buy pho and a coffee for every morning (´・ω・｀): [Paypal](https://www.paypal.me/tekun0lxrd)
