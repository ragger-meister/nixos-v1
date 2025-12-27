# NixOS SOTA Workstation

Minimal NixOS workstation with Hyprland, following KISS principles.

```
system/    base (boot, network, security, services, dev, maintenance)
user/      identity (shell, terminal, browser, tools)
desktop/   graphics (hyprland, waybar, mako, fuzzel, lightdm)
themes/    aesthetics (tokyo night)
state/     persistence policy
secrets/   credentials management
assets/    static files (firefox-chrome)
```

## Requirements

- UEFI-capable system
- 4GB+ RAM (ZRAM enabled)
- x86_64 architecture

## Quick Test

```bash
# VM (quick test)
nix build .#nixosConfigurations.nixos.config.system.build.vm
./result/bin/run-nixos-vm

# ISO (bootable USB)
nix build .#nixosConfigurations.iso.config.system.build.isoImage
# result/iso/nixos-*.iso -> write to USB with dd or ventoy
```

## Installation

### 1. Boot from NixOS ISO

Boot your target machine from a NixOS installation ISO.

### 2. Network Setup

```bash
# Wired: automatic via DHCP
# Wireless:
nmcli device wifi connect "SSID" password "PASSWORD"
```

### 3. Partition Disks

```bash
# Example for a single disk (adjust /dev/nvme0n1 to your disk)
parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 512MiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary ext4 512MiB 100%

mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/nvme0n1p2

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
```

### 4. Clone Repository

```bash
nix-shell -p git
git clone https://github.com/ragger-meister/nixos-v1.git /mnt/etc/nixos
cd /mnt/etc/nixos
```

### 5. Configure

```bash
# Generate hardware configuration
nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/system/hosts/workstation/hardware-configuration.nix

# Edit flake.nix to set your username (default: anton)
vim flake.nix
```

### 6. Optional: VPN Configuration

```bash
cp system/modules/vpn.nix.example system/modules/vpn.nix
vim system/modules/vpn.nix
# Add vpn.nix to system/default.nix imports
```

### 7. Install

```bash
nixos-install --flake /mnt/etc/nixos#nixos --no-root-passwd
reboot
```

### 8. Post-Installation

```bash
# Set user password
passwd

# Add wallpaper
cp your-wallpaper.jpg ~/Pictures/wallpaper.jpg

# Run system audit
system-audit
```

## Daily Operations

### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| SUPER+Return | Terminal |
| SUPER+Space | Launcher |
| SUPER+B | Browser (Firefox) |
| SUPER+E | Files (yazi) |
| SUPER+T | Telegram (nchat) |
| SUPER+D | Documents (zathura) |
| SUPER+M | Mail (aerc) |
| SUPER+G | Git (lazygit) |
| SUPER+N | IDE (neovim) |
| SUPER+V | Volume (pavucontrol) |
| SUPER+P | Screenshot (region) |
| SUPER+Shift+P | Screenshot (full) |
| SUPER+R | Record (region) |
| SUPER+Shift+R | Stop recording |
| SUPER+O | Lock screen |
| SUPER+Q | Close window |
| SUPER+F | Fullscreen |
| SUPER+Shift+F | Toggle floating |
| SUPER+H/J/K/L | Focus left/down/up/right |
| SUPER+Shift+H/J/K/L | Move window |
| SUPER+Ctrl+H/J/K/L | Resize window |
| SUPER+1-9 | Switch workspace |
| SUPER+/ | Show shortcuts help |

### System Management

```bash
# System audit
system-audit

# Update system
doas nixos-rebuild switch --flake /etc/nixos#nixos

# Update flake inputs
nix flake update

# Manual garbage collection
doas nix-collect-garbage --delete-older-than 30d

# Rollback to previous generation
doas nixos-rebuild switch --rollback
```

### SSH Access

```bash
# From another machine
ssh anton@<ip-address>

# Key-based auth only (no passwords)
# Add your public key to ~/.ssh/authorized_keys
```

## Maintenance

Automatic maintenance runs every Sunday at 04:00:
- System upgrade (04:00)
- Garbage collection (04:30)
- Store optimization (05:00)

## Security

- Firewall: nftables with default deny
- SSH: Key-based auth only, no root login
- Privilege: doas (no sudo)
- Hardening: AppArmor, fail2ban, auditd
- Secrets: age/sops for credential management

## Troubleshooting

### Black screen after login
```bash
# Check Hyprland logs
cat ~/.local/share/hyprland/hyprland.log
```

### No audio
```bash
# Restart PipeWire
systemctl --user restart pipewire wireplumber
```

### VPN not connecting
```bash
# Check WireGuard status
doas wg show
doas journalctl -u wg-quick-wg0
```
