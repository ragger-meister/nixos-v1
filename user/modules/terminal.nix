{ config, pkgs, theme, themeLib, ... }:

{
  programs.kitty = {
    enable = true;
    settings = themeLib.kitty;
  };

  programs.alacritty = {
    enable = true;
    settings = themeLib.alacritty;
  };
}
