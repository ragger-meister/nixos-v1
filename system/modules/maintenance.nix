{ config, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos";
    operation = "switch";
    dates = "Sun *-*-* 04:00:00";
    allowReboot = false;
  };

  nix.gc = {
    automatic = true;
    dates = "Sun *-*-* 04:30:00";
    options = "--delete-older-than 30d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "Sun *-*-* 05:00:00" ];
  };

  nix.settings = {
    min-free = 5368709120;
    max-free = 16106127360;
    auto-optimise-store = true;
  };

  environment.systemPackages = with pkgs; [
    restic
    rclone
    syncthing
  ];
}
