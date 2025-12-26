{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      userChrome = builtins.readFile ../../assets/firefox-chrome/userChrome.css;
      userContent = builtins.readFile ../../assets/firefox-chrome/userContent.css;
      extraConfig = builtins.readFile ../../assets/firefox-chrome/user.js;
    };
  };
}
