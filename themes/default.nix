{ ... }:

{
  colors = {
    bg = "#1a1b26";
    bg-dark = "#15161e";
    bg-highlight = "#24283b";
    fg = "#a9b1d6";
    fg-bright = "#c0caf5";
    fg-dark = "#565f89";
    accent = "#7aa2f7";
    accent-alt = "#cc6324";
    red = "#f7768e";
    green = "#9ece6a";
    yellow = "#e0af68";
    blue = "#7aa2f7";
    magenta = "#bb9af7";
    cyan = "#7dcfff";
    border = "#7aa2f7";
    selection = "#33467c";
    cursor = "#c0caf5";
  };

  fonts = {
    mono = {
      name = "Iosevka Nerd Font";
      package = "nerdfonts";
      size = {
        terminal = 12;
        ui = 11;
        bar = 15;
        launcher = 36;
      };
    };
  };

  cursor = {
    name = "Bibata-Modern-Classic";
    package = "bibata-cursors";
    size = 24;
  };

  gtk = {
    theme = "adw-gtk3-dark";
    iconTheme = "Papirus-Dark";
  };

  ui = {
    borderWidth = 1;
    borderRadius = 0;
    gaps = 0;
  };
}
