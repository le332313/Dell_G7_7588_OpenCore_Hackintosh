# Dell_G7_7588_OpenCore_Hackintosh
## Update Nov 13, 2020: EFI is now supported macOS Big Sur Release version build 20B29!

## Overview
![screenshot](https://cdn.discordapp.com/attachments/496510149658279939/776730491650965515/Screen_Shot_2020-11-13_at_15.47.55.png)
- Lastest macOS Big Sur 11.0.1 Release
- Bootloader: OpenCore 0.6.3
- There are 2 EFI folders, one for Intel card user, one for DW1560 card user. They can be used both for USB Installer and booting.
- I merged all SSDTs into one file.

## Hardware configuration
* Dell G7 7588
  - CPU: i7-8750H
  - RAM: 16Gb 2x DDR4 (upgraded)
  - Display: 1080p
  - SSD: 
      * M.2 SATA Kingston SM2280S3G2120G 120Gb for macOS
      * 2.5 inch SATAIII Crucial CT500MX500SSD1 500Gb for Windows 10 and data
  - Sound: ALC256
  - Wireless + Bluetooth: Replaced with BCM94352Z aka DW1560
  - VGA: Nvidia GTX 1050Ti (disabled)
  - BIOS: 1.14.0 (latest)
  
## Graphics
Integrated Intel UHD Graphics 630 support is handled by WhateverGreen, and configured in the `PciRoot(0x0)/Pci(0x2,0x0)` section of `config.plist`.
The Nvidia GPU is not supported so it is disabled in SSDT.
The default BIOS DVMT pre-alloc value of `64MB` is sufficient and does not need to be changed.
### Enabling acceleration
* DeviceProperties/Add/PciRoot(0x0)/Pci(0x2,0x0)
  * `AAPL,ig-platform-id = <0900A53E>`
### Enabling external display support
* Boot Arguments
  * `agdpmod=vit9696`
* DeviceProperties/Add/PciRoot(0x0)/Pci(0x2,0x0)
  * `framebuffer-patch-enable = <01000000>`
  * `framebuffer-pipecount = <02000000>`
  * `framebuffer-portcount = <02000000>`
  * `framebuffer-con1-enable = <00040000>`
  * `framebuffer-con1-type = <01000000>`
  * `framebuffer-con1-alldata = <01050900 00040000 C7010000>`
### Fixing iGPU Performance
* DeviceProperties/Add/PciRoot(0x0)/Pci(0x2,0x0)
  * `igfxfw = <02000000>`

## Brightness
Brightness slider and brightness keys are enabled using `BRT6 Method`, already in SSDT.
Also there is a rename in `ACPI/Patch`.
  - Comment: change BRT6 to BRTX
  - Count: 0
  - Limit: 0
  - Enable: Yes
  - Find: 14204252 543602
  - Replace: 14204252 545802

## iMessages and Facetime
Follow [this guide](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html) from Dortania.
- Make sure you have to change the ROM in `PlatformInfo/Generic/ROM`.
- You should get a new valid serial number and other SMBIOS related data for iMessage/Facetime to work, with the SMBIOS is `MacBookPro15,1`. Use [Corpnewt's GenSMBIOS](https://github.com/corpnewt/GenSMBIOS).

## Audio
- For ALC256, I use `layout-id = <21>`. This id can give you 3.5mm headphone jack (just headphone!).
- For fixing headset jack, run the `install.sh` in `AudioJack Fixup` folder. You can use the external microphone.
- credit: [Ivs1974](https://github.com/lvs1974/ComboJack)

## Thunderbolt 3
- Thunderbolt device will work in macOS when attached prior to boot, but will lose functionality when hotplugged. So make sure you have to plug it first, then power on the laptop and boot into macOS, it will be worked!

## Touch ID/Goodix Fingerprint Sensor
* Since I'm using the `MacBookPro15,1` SMBIOS, macOS is expecting Touch ID to be available, causing lag on password prompts. So it can be disabled using `NoTouchID.kext`.

## Keyboard and Trackpad
* The keyboard is PS2, so I use `VoodooPS2Controller.kext`. But I have already deleted `VoodooInput.kext`, `VoodooPS2Trackpad.kext` and `VoodooPS2Mouse.kext` plugins inside because of some stupid things and not need.
* The trackpad is from Synaptics, but it is I2C-HID device. So it can be driven with VoodooI2C, also provides basic trackpad support. For me, I use `VoodooI2C.kext` and `VoodooI2CHID.kext`.

## Power Management, Sleep, Wake and Hibernation
* Hibernation is not supported on a Hackintosh and everything related to it should be completely disabled. Disabling additional features prevents random wakeups while the lid is closed. After every update, these settings should be reapplied manually.
* Run these commands in Terminal and done:
```
sudo pmset -a hibernatemode 0
sudo rm -f /var/vm/sleepimage
sudo mkdir /var/vm/sleepimage
sudo pmset -a standby 0
sudo pmset -a autopoweroff 0
sudo pmset -a powernap 0
sudo pmset -a proximitywake 0
```

## System Integrity Protection (SIP) and Apple Secure Boot
* SIP is enable.
* About Apple Secure Boot, `DmgLoading` is set to `Signed`, and `SecureBootModel` is `j680`. For more infomation, you can check it [here](https://dortania.github.io/OpenCore-Post-Install/universal/security/applesecureboot.html).

## CFG-Unlock (Highly recommended)
* Run `modGRUBShell.efi` at OpenCore menu boot screen.
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
* Support me ʕ•ᴥ•ʔ☆: [Paypal](https://www.paypal.me/tekun0lxrd)
