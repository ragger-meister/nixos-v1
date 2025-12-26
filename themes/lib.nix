{ theme }:

let
  colors = theme.colors;
  fonts = theme.fonts;
in
{
  kitty = {
    font_family = fonts.mono.name;
    font_size = fonts.mono.size.terminal;
    background = colors.bg;
    foreground = colors.fg;
    cursor = colors.cursor;
    selection_background = colors.selection;
    color0 = colors.bg-dark;
    color8 = colors.fg-dark;
    color1 = colors.red;
    color9 = colors.red;
    color2 = colors.green;
    color10 = colors.green;
    color3 = colors.yellow;
    color11 = colors.yellow;
    color4 = colors.blue;
    color12 = colors.blue;
    color5 = colors.magenta;
    color13 = colors.magenta;
    color6 = colors.cyan;
    color14 = colors.cyan;
    color7 = colors.fg;
    color15 = colors.fg-bright;
    window_padding_width = 8;
    enable_audio_bell = false;
  };

  alacritty = {
    font.normal.family = fonts.mono.name;
    font.size = fonts.mono.size.terminal;
    colors.primary = {
      background = colors.bg;
      foreground = colors.fg;
    };
  };

  waybarStyle = ''
    * {
      border: none;
      font-family: "${fonts.mono.name}";
      font-size: ${toString fonts.mono.size.bar}px;
      min-height: 0;
    }
    window#waybar {
      background: ${colors.bg};
      color: ${colors.accent-alt};
    }
    #workspaces button {
      padding: 0 8px;
      color: ${colors.fg-dark};
      background: transparent;
    }
    #workspaces button.active {
      color: ${colors.accent};
    }
    #custom-package, #custom-files, #custom-docs, #custom-mail,
    #custom-browser, #custom-ide, #custom-terminal, #custom-stagit,
    #custom-telegram, #custom-vpn, #custom-power,
    #clock, #pulseaudio {
      padding: 0 10px;
    }
    #custom-package:hover, #custom-files:hover, #custom-docs:hover,
    #custom-mail:hover, #custom-browser:hover, #custom-ide:hover,
    #custom-terminal:hover, #custom-stagit:hover, #custom-telegram:hover,
    #custom-vpn:hover, #custom-power:hover {
      background: ${colors.bg-highlight};
    }
  '';

  mako = {
    backgroundColor = colors.bg;
    textColor = colors.fg;
    borderColor = colors.border;
    borderRadius = theme.ui.borderRadius;
    borderSize = theme.ui.borderWidth;
    font = "${fonts.mono.name} ${toString fonts.mono.size.ui}";
    defaultTimeout = 5000;
  };

  fuzzel = {
    main = {
      icons-enabled = false;
      font = "${fonts.mono.name}:size=${toString fonts.mono.size.launcher}";
      terminal = "kitty";
    };
    colors = {
      background = "${builtins.substring 1 6 colors.bg}ff";
      text = "${builtins.substring 1 6 colors.fg}ff";
      selection = "${builtins.substring 1 6 colors.bg-highlight}ff";
      selection-text = "${builtins.substring 1 6 colors.fg-bright}ff";
      border = "${builtins.substring 1 6 colors.border}ff";
    };
    border = {
      width = theme.ui.borderWidth;
      radius = theme.ui.borderRadius;
    };
    dimensions = {
      width = 80;
      lines = 18;
    };
  };

  hyprland = {
    general = {
      gaps_in = theme.ui.gaps;
      gaps_out = theme.ui.gaps;
      border_size = theme.ui.borderWidth;
      "col.active_border" = "rgba(${builtins.substring 1 6 colors.accent}ee)";
      "col.inactive_border" = "rgba(${builtins.substring 1 6 colors.bg}aa)";
      layout = "dwindle";
    };
    decoration = {
      rounding = theme.ui.borderRadius;
      shadow.enabled = false;
    };
  };

  hyprlockConf = ''
    background {
      color = rgba(26, 27, 38, 1.0)
    }
    input-field {
      size = 300, 50
      outline_thickness = ${toString theme.ui.borderWidth}
      outer_color = rgba(122, 162, 247, 1)
      inner_color = rgba(26, 27, 38, 1)
      font_color = rgba(169, 177, 214, 1)
      fade_on_empty = false
      placeholder_text = Password
      position = 0, 0
      halign = center
      valign = center
    }
  '';

  lightdmMini = ''
    [greeter]
    show-password-label = false
    show-input-cursor = false
    password-alignment = center
    password-input-width = 32
    [greeter-theme]
    font = "${fonts.mono.name}"
    font-size = 1.20em
    background-image = "/etc/lightdm/suckless.png"
    background-color = "${colors.bg}"
    window-color = "${colors.bg}"
    border-color = "${colors.bg}"
    border-width = 0px
    layout-space = 6
    password-color = "${colors.fg}"
    password-background-color = "${colors.bg}"
    password-border-color = "${colors.accent-alt}"
    password-border-width = 1px
    password-border-radius = 0.70em
  '';
}
