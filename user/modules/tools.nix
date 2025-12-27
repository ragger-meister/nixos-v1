{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    yazi
    lazygit
    aerc
    zk
    mpv
    ffmpeg
    imv
    zathura
    stagit
    zola
    nchat
    btop
  ];
}
