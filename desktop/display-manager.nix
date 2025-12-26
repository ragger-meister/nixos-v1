{ config, pkgs, theme, themeLib, ... }:

let
  asciiText = pkgs.writeText "suckless-ansishadow.txt" ''
███████╗██╗   ██╗ ██████╗██╗  ██╗██╗     ███████╗███████╗███████╗
██╔════╝██║   ██║██╔════╝██║ ██╔╝██║     ██╔════╝██╔════╝██╔════╝
███████╗██║   ██║██║     █████╔╝ ██║     █████╗  ███████╗███████╗
╚════██║██║   ██║██║     ██╔═██╗ ██║     ██╔══╝  ╚════██║╚════██║
███████║╚██████╔╝╚██████╗██║  ██╗███████╗███████╗███████║███████║
╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝
'';

  sucklessBg = pkgs.runCommand "suckless-bg" {
    nativeBuildInputs = [ pkgs.imagemagick pkgs.dejavu_fonts ];
  } ''
    set -euo pipefail
    mkdir -p "$out"
    ${pkgs.imagemagick}/bin/magick \
      -background none \
      -fill "${theme.colors.accent-alt}" \
      -font ${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf \
      -pointsize 17 \
      -interline-spacing 4 \
      label:@${asciiText} \
      -trim +repage \
      -resize 850x \
      "$TMPDIR/text.png"
    ${pkgs.imagemagick}/bin/magick \
      -size 1920x1080 xc:"${theme.colors.bg}" \
      "$TMPDIR/text.png" \
      -gravity Center -geometry +0-240 -composite \
      "$out/suckless.png"
  '';
in
{
  services.displayManager.defaultSession = "hyprland";

  services.xserver = {
    enable = true;
    xkb = { layout = "es"; variant = ""; };
    displayManager.lightdm = {
      enable = true;
      greeters = {
        gtk.enable = false;
        slick.enable = false;
        mini = {
          enable = true;
          user = "anton";
          extraConfig = themeLib.lightdmMini;
        };
      };
    };
  };

  system.activationScripts.lightdmSucklessBackground.text = ''
    install -D -m 0644 ${sucklessBg}/suckless.png /etc/lightdm/suckless.png
    chown root:root /etc/lightdm/suckless.png
  '';

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })
    pkgs.iosevka
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
