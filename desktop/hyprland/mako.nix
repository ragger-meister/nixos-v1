{ config, pkgs, theme, themeLib, ... }:

{
  services.mako = {
    enable = true;
  } // themeLib.mako;
}
