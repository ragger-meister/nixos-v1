{ config, pkgs, ... }:

{
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
  ];
}
