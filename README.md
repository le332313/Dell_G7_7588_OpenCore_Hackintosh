# Dell_G7_7588_OpenCore_Hackintosh
## Good new: There is an EFI folder created for Big Sur 11.0.1 Beta and can boot smoothy. You can use it.
## Overview
![screenshot](https://cdn.discordapp.com/attachments/496510149658279939/775688424719515658/Screen_Shot_2020-11-10_at_18.44.29.png)
- Lastest macOS Catalina 10.15.7 (also a folder for Big Sur 11.0.1 Beta)
- Bootloader: OpenCore 0.6.3
- EFI folder can be used both for USB Installer and booting.
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

## Brightness
Brightness slider and brightness keys are enabled using `SSDT-PNLF-BRT6.aml`.
Also there is a rename BRT6 to BRTX in `ACPI/Patch`.
  - Comment: change BRT6 to BRTX
  - Count: 0
  - Limit: 0
  - Enable: Yes
  - Find: 14204252 543602
  - Replace: 14204252 545802

## Wi-Fi and Bluetooth
1. For Intel user:
- Go `Wireless/Bluetooth Kexts` folder and copy all kexts from `Intel AC 9560` folder to `OC/Kexts`
- I recommend you should use [ProperTree](https://github.com/corpnewt/ProperTree) to clean snapshot the `config.plist` file.
- Set `SecureBootModel` from `Disabled` to `Default`. Intel user HAVE TO do this because of `AirportItlwm.kext`.
2. For Broadcom user:
- Grab all kexts from `DW1560/1820a` folder and put them to `OC/Kexts`
- Open `config.plist`, go `DeviceProperties > Add` and add the following patch. For example, this is my DW1560 with VendorID = 0x14E4, DeviceID = 0x43B1 (You can check it from Hackintool and replace with your in `compatible` key)
    * `PciRoot(0x0)/Pci(0x1D,0x6)/Pci(0x0,0x0)`
        * `AAPL,slot-name =  WLAN`
        * `compatible = pci14e4,43b1`
        * `device_type = Airport Extreme`
        * `model = Dell DW1560 802.11ac Wireless`
        * `name = Airport`
- NOTE for DW1820a user: Because the BCM94350ZAE chipset doesn't support power management correctly in macOS so needs to be disabled via property injection. You should add one more the following key for disable the apsm:
    `pci-aspm-default = 00000000`
    + You HAVE TO patch this key first. Then shutdown and plug the DW1820a. If not, you can't boot into macOS.
    + Also, you change the `model` and `compatible` key name later.
    + There is another way: You can disable the `WLAN` and `Bluetooth` setting in BIOS first, go to macOS, find the VendorID and DeviceID, then patch, then restart, go BIOS, enable them, then back, then boot into macOS :^). I'm not sure about this way because I haven't tried it before *teehee

## iMessages and Facetime
Follow [this guide](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html) from Dortania.
- Make sure you have to change the ROM in `PlatformInfo/Generic/ROM`.
- Also I highly recommend you should get a new valid serial number and other SMBIOS related data for iMessage/Facetime to work. You can use [Corpnewt's GenSMBIOS](https://github.com/corpnewt/GenSMBIOS).

## Audio
- For ALC256, I use `layout-id = <21>`. This id can give you 3.5mm headphone jack (just headphone!).
- For fixing headset jack, run the `install.sh` in `AudioJackFixup` folder. You can use the external microphone.
- credit: [Ivs1974](https://github.com/lvs1974/ComboJack)

## Thunderbolt 3
- Thunderbolt device will work in macOS when attached prior to boot, but will lose functionality when hotplugged. So make sure you have to plug it first, then power on the laptop and boot into macOS, it will work!

## Touch ID/Goodix Fingerprint Sensor
* Since I'm using the `MacBookPro15,1` SMBIOS, macOS is expecting Touch ID to be available, causing lag on password prompts. So it can be disabled using `NoTouchID.kext`.

## Keyboard and Trackpad
* The keyboard is PS2, so I use `VoodooPS2Controller.kext`. But I already deleted `VoodooInput.kext`, `VoodooPS2Trackpad.kext` and `VoodooPS2Mouse.kext` plugin inside because of some stupid things and not need.
* The trackpad is from Synaptics, but is I2C-HID device. So it can be driven with VoodooI2C, also provides basic trackpad support. For me, I use `VoodooI2C.kext` and `VoodooI2CHID.kext`.

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

## System Integrity Protection (SIP)
* SIP is disabled. I hate SIP.

## HiDPI
* I recommend you should install manually. Download [Hackintool](https://github.com/headkaze/Hackintool), extract and put it to Applications
* Run it, go to Utilities tab, click ![Disable Gatekeeper](https://cdn.discordapp.com/attachments/719556350161584179/765493559649894430/unknown.png) icon. This icon means Hackintool will disable the Gatekeeper and mount the disk in read/write mode.
* When ![Success](https://cdn.discordapp.com/attachments/719556350161584179/765493356984926249/unknown.png) shows up, it means successful. Now go to `/System/Library/Displays/Contents/Resources/Overrides/`, rename the current `Icons.plist` to another name, like `IconsBackup.plist`.
* Copy `DisplayVendorID-30e4` folder and `Icons.plist` to `Overrides` folder. If everything is okay, restart your laptop to take effect.

## CFG-Unlock (Highly recommended)
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
* Support me to top up Genesis Crystals in Genshin Impact ʕ•ᴥ•ʔ☆: [Paypal](https://www.paypal.me/tekun0lxrd)
