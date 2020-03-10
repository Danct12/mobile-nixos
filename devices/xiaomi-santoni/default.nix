{ config, lib, pkgs, ... }:

{
  mobile.device.name = "xiaomi-santoni";
  mobile.device.info = rec {
    format_version = "0";
    name = "Xiaomi Redmi 4X";
    manufacturer = "Xiaomi";
    date = "2017";
    modules_initfs = "";
    arch = "aarch64";
    keyboard = false;
    external_storage = true;
    screen_width = "720";
    screen_height = "1280";
    dev_touchscreen = "/dev/input/event1";
    flash_method = "fastboot";
    kernel_cmdline = lib.concatStringsSep " " [
      "androidboot.hardware=qcom"
      "msm_rtb.filter=0x237"
      "ehci-hcd.park=3"
      "lpm_levels.sleep_disabled=1"
      "androidboot.bootdevice=7824900.sdhci"
      "earlycon=msm_hsl_uart,0x78B0000"
      "androidboot.selinux=permissive"
      "buildvariant=userdebug"
    ];
    generate_bootimg = true;
    flash_offset_base = "0x80000000";
    flash_offset_kernel = "0x00008000";
    flash_offset_ramdisk = "0x01000000";
    flash_offset_second = "0x00f00000";
    flash_offset_tags = "0x00000100";
    flash_pagesize = "4096";
    kernel = pkgs.callPackage ./kernel { kernelPatches = pkgs.defaultKernelPatches; };
  };
  mobile.hardware = {
    soc = "qualcomm-msm8940";
    ram = 1024 * 4;
    screen = {
      width = 720; height = 1280;
    };
  };

  mobile.usb.mode = "android_usb";
  # Xiaomi Communications Co., Ltd.
  mobile.usb.idVendor = "2717";
  # Mi/Redmi series (RNDIS)
  mobile.usb.idProduct = "FF80";

  mobile.system.type = "android";
}
