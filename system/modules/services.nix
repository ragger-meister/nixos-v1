{ config, pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

  services.printing.enable = true;
  hardware.sane.enable = true;

  services.udisks2.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
    playerctl
    brightnessctl
  ];
}
