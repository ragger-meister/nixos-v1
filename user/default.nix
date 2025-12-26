{ config, pkgs, lib, theme, themeLib, user, ... }:

{
  imports = [
    ./modules/shell.nix
    ./modules/terminal.nix
    ./modules/browser.nix
    ./modules/tools.nix
  ];

  home.username = user.name;
  home.homeDirectory = user.home;
  home.stateVersion = "24.11";

  home.pointerCursor = {
    name = theme.cursor.name;
    package = pkgs.bibata-cursors;
    size = theme.cursor.size;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = theme.gtk.theme;
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = theme.gtk.iconTheme;
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = theme.fonts.mono.name;
      size = theme.fonts.mono.size.ui;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  xdg.configFile."qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=gtk2
    icon_theme=${theme.gtk.iconTheme}
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=gtk2
    icon_theme=${theme.gtk.iconTheme}
  '';

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bibata-cursors
    papirus-icon-theme
    adw-gtk3
  ];
}
