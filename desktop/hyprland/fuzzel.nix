{ config, pkgs, theme, themeLib, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = themeLib.fuzzel;
  };
}
