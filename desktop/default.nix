{ config, pkgs, lib, theme, themeLib, ... }:

{
  imports = [
    ./hyprland
    ./display-manager.nix
  ];
}
