{ config, pkgs, lib, theme, themeLib, ... }:

let
  fuzzelPower = pkgs.writeShellScriptBin "fuzzel-power" ''
    set -euo pipefail

    prompt="Power: "
    items=$'Power off\nRestart\nCancel\n'

    maxlen="$(printf "%s" "$items" | ${pkgs.gawk}/bin/awk '{ if (length>m) m=length } END{print m}')"
    width=$((maxlen + 25))
    (( width < 32 )) && width=32
    (( width > 40 )) && width=40

    args=(--dmenu --prompt "$prompt" --font "${theme.fonts.mono.name}:size=26" --width "$width" --lines 3 --horizontal-pad 28 --vertical-pad 14)

    help="$(${pkgs.fuzzel}/bin/fuzzel --help 2>&1 || true)"
    ${pkgs.gnugrep}/bin/grep -q -- '--minimal-lines' <<<"$help" && args+=(--minimal-lines)
    ${pkgs.gnugrep}/bin/grep -q -- '--dpi-aware'      <<<"$help" && args+=(--dpi-aware=no)

    choice="$(printf "%s" "$items" | ${pkgs.fuzzel}/bin/fuzzel "''${args[@]}")" || exit 0

    case "$choice" in
      "Power off") systemctl poweroff ;;
      "Restart")   systemctl reboot ;;
      *) exit 0 ;;
    esac
  '';
in
{
  imports = [
    ./waybar.nix
    ./mako.nix
    ./fuzzel.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      windowrulev2 = noborder, class:^(org.telegram.desktop)$
      windowrulev2 = noshadow, class:^(org.telegram.desktop)$
      windowrulev2 = noblur, class:^(org.telegram.desktop)$
      windowrulev2 = noanim, class:^(org.telegram.desktop)$
      windowrulev2 = rounding 0, class:^(org.telegram.desktop)$
    '';
    settings = {
      general = themeLib.hyprland.general;
      decoration = themeLib.hyprland.decoration;
      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };
      input = {
        kb_layout = "es";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
      };
      monitor = ",preferred,auto,1";
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod SHIFT, Q, exec, true"
        "$mod ALT, Q, exec, true"
        "$mod, Space, exec, fuzzel"
        "$mod, B, exec, firefox"
        "$mod, E, exec, kitty -e yazi"
        "$mod, T, exec, kitty -e nchat"
        "$mod, D, exec, zathura"
        "$mod, M, exec, kitty -e aerc"
        "$mod, G, exec, kitty -e lazygit"
        "$mod, V, exec, pavucontrol"
        "$mod, N, exec, kitty -e nvim"
        "$mod, S, exec, kitty -e stagit"
        "$mod, A, exec, kitty -e doas nix-env -qaP"
        "$mod, P, exec, grim -g \"$(slurp)\" ~/Pictures/$(date +%Y%m%d_%H%M%S).png"
        "$mod SHIFT, P, exec, grim ~/Pictures/$(date +%Y%m%d_%H%M%S).png"
        "$mod, R, exec, wf-recorder -g \"$(slurp)\" -f ~/Videos/$(date +%Y%m%d_%H%M%S).mp4"
        "$mod SHIFT, R, exec, pkill -SIGINT wf-recorder"
        "$mod, O, exec, hyprlock"
        ''$mod, slash, exec, kitty -e sh -c 'printf "%s\n" "SHORTCUTS:" "SUPER+Return=Term" "SUPER+Space=Launcher" "SUPER+B=Browser" "SUPER+E=Files" "SUPER+T=Telegram" "SUPER+D=Docs" "SUPER+M=Mail" "SUPER+G=Git" "SUPER+N=IDE" "SUPER+S=Stagit" "SUPER+A=Package" "SUPER+V=Volume" "SUPER+P=Screenshot" "SUPER+R=Record" "SUPER+O=Lock" "SUPER+Q=Close" "SUPER+F=Fullscreen" | less' ''
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
        "$mod, F, fullscreen"
        "$mod SHIFT, F, togglefloating"
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"
        "$mod CTRL, H, resizeactive, -50 0"
        "$mod CTRL, L, resizeactive, 50 0"
        "$mod CTRL, K, resizeactive, 0 -50"
        "$mod CTRL, J, resizeactive, 0 50"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      exec-once = [
        "hyprpaper"
        "waybar"
        "mako"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "hypridle"
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 3600;
          on-timeout = "hyprlock";
        }
        {
          timeout = 3660;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/wallpaper.jpg
    wallpaper = ,~/Pictures/wallpaper.jpg
    splash = false
  '';

  home.file.".config/hypr/hyprlock.conf".text = themeLib.hyprlockConf;

  home.packages = with pkgs; [
    kitty
    alacritty
    nyxt
    grim
    slurp
    wl-clipboard
    wf-recorder
    hyprlock
    hypridle
    hyprpaper
    libnotify
    polkit_gnome
    fuzzelPower
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    iosevka
  ];
}
