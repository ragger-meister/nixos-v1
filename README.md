# NixOS SOTA

```
system/    base (boot, network, security, services)
user/      identity (shell, terminal, tools)
desktop/   graphics (hyprland, waybar, mako, fuzzel)
themes/    aesthetics (tokyo night)
state/     persistence policy
secrets/   credentials
assets/    static files (firefox-chrome)
```

## Setup

1. Edit `flake.nix`: set `user.name` and `user.home`
2. Generate hardware config:
   ```bash
   sudo nixos-generate-config --show-hardware-config > system/hosts/workstation/hardware-configuration.nix
   ```
3. Optional: copy `system/modules/vpn.nix.example` to `vpn.nix` and configure
4. Build:
   ```bash
   sudo nixos-rebuild switch --flake .#nixos
   ```
