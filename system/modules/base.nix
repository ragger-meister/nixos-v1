{ config, pkgs, user, ... }:

{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";

  security.doas.enable = true;
  security.doas.extraRules = [{
    users = [ user.name ];
    keepEnv = true;
    noPass = true;
  }];
  security.sudo.enable = false;

  programs.dconf.enable = true;

  users.users.${user.name} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "scanner" "lp" ];
  };

  environment.systemPackages = with pkgs; [
    git vim curl wget htop tree
    ripgrep fd fzf bat jq
    rsync mtr dnsutils
    strace lsof tcpdump
    smartmontools nvme-cli lm_sensors
    zip unzip p7zip
    exfatprogs ntfs3g
    alejandra
    lnav
  ];
}
