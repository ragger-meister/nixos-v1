{ config, pkgs, theme, themeLib, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = [{
      layer = "top";
      position = "bottom";
      height = 28;
      modules-left = [ "custom/package" "custom/files" "custom/docs" "custom/mail" "custom/browser" "custom/ide" "custom/terminal" "custom/stagit" ];
      modules-center = [];
      modules-right = [ "custom/power" "clock#date" "clock#time" "pulseaudio" "custom/vpn" "custom/telegram" ];

      "custom/package" = {
        format = "PACKAGE";
        on-click = "kitty -e sh -c 'echo \"NixOS Package Manager\n\nSearch: nix search nixpkgs <term>\nInstall: doas nix-env -iA nixpkgs.<pkg>\nUpdate: doas nixos-rebuild switch --flake /etc/nixos\nGC: doas nix-collect-garbage -d\n\nPress q to exit\" | less'";
        tooltip = false;
      };
      "custom/files" = {
        format = "FILE";
        on-click = "kitty -e yazi";
        tooltip = false;
      };
      "custom/docs" = {
        format = "DOCUMENT";
        on-click = "zathura";
        tooltip = false;
      };
      "custom/mail" = {
        format = "MESSAGING";
        on-click = "kitty -e aerc";
        tooltip = false;
      };
      "custom/browser" = {
        format = "BROWSER";
        on-click = "firefox";
        tooltip = false;
      };
      "custom/ide" = {
        format = "IDE";
        on-click = "kitty -e nvim";
        tooltip = false;
      };
      "custom/terminal" = {
        format = "TERMINAL";
        on-click = "kitty";
        tooltip = false;
      };
      "custom/stagit" = {
        format = "STAGIT";
        on-click = "kitty -e lazygit";
        tooltip = false;
      };
      "custom/telegram" = {
        format = "TELEGRAM";
        on-click = "kitty -e nchat";
        tooltip = false;
      };
      "custom/vpn" = {
        format = "VPN";
        interval = 10;
        exec = "if ip link show wg0 &>/dev/null; then echo 'VPN:ON'; else echo 'VPN:OFF'; fi";
        on-click = "kitty -e sh -c 'doas wg show; read'";
        tooltip = false;
      };
      "custom/power" = {
        format = "POWER";
        on-click = "fuzzel-power";
        tooltip = false;
      };
      "clock#time" = {
        format = "{:%I:%M %p}";
      };
      "clock#date" = {
        format = "{:%d %b}";
      };
      pulseaudio = {
        format = "VOL {volume}%";
        format-muted = "MUTED";
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-scroll-up = "wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
        on-scroll-down = "wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%-";
        max-volume = 100;
      };
    }];
    style = themeLib.waybarStyle;
  };
}
