{ config, pkgs, user, ... }:

let
  systemAudit = pkgs.writeShellScriptBin "system-audit" ''
    set -euo pipefail
    echo "=== SYSTEM AUDIT REPORT ==="
    echo "Date: $(date)"
    echo ""
    echo "=== HARDWARE ==="
    echo "CPU: $(${pkgs.gnugrep}/bin/grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | xargs)"
    echo "Cores: $(${pkgs.coreutils}/bin/nproc)"
    echo ""
    echo "=== MEMORY ==="
    ${pkgs.procps}/bin/free -h
    echo ""
    echo "=== ZRAM ==="
    ${pkgs.zramctl}/bin/zramctl 2>/dev/null || echo "No zram devices"
    echo ""
    echo "=== DISK USAGE ==="
    ${pkgs.coreutils}/bin/df -h / /boot /nix 2>/dev/null || true
    echo ""
    echo "=== NETWORK ==="
    echo "Hostname: $(${pkgs.nettools}/bin/hostname)"
    ${pkgs.iproute2}/bin/ip -br addr 2>/dev/null || true
    echo ""
    echo "=== VPN STATUS ==="
    ${pkgs.iproute2}/bin/ip link show wg0 2>/dev/null && echo "WireGuard: ACTIVE" || echo "WireGuard: INACTIVE"
    echo ""
    echo "=== CRITICAL SERVICES ==="
    ${pkgs.systemd}/bin/systemctl is-active sshd.service 2>/dev/null && echo "SSH: ACTIVE" || echo "SSH: INACTIVE"
    ${pkgs.systemd}/bin/systemctl is-active NetworkManager.service 2>/dev/null && echo "NetworkManager: ACTIVE" || echo "NetworkManager: INACTIVE"
    ${pkgs.systemd}/bin/systemctl is-active fail2ban.service 2>/dev/null && echo "fail2ban: ACTIVE" || echo "fail2ban: INACTIVE"
    ${pkgs.systemd}/bin/systemctl is-active pipewire.service --user 2>/dev/null && echo "PipeWire: ACTIVE" || echo "PipeWire: INACTIVE"
    echo ""
    echo "=== NIX GENERATIONS ==="
    doas nix-env --list-generations -p /nix/var/nix/profiles/system 2>/dev/null | tail -5 || echo "Cannot list generations"
    echo ""
    echo "=== RECENT LOGS (ERRORS) ==="
    ${pkgs.systemd}/bin/journalctl -p err -n 10 --no-pager 2>/dev/null || true
    echo ""
    echo "=== SECURITY STATUS ==="
    ${pkgs.systemd}/bin/systemctl is-active apparmor.service 2>/dev/null && echo "AppArmor: ACTIVE" || echo "AppArmor: INACTIVE"
    ${pkgs.systemd}/bin/systemctl is-active auditd.service 2>/dev/null && echo "Audit: ACTIVE" || echo "Audit: INACTIVE"
    echo ""
    echo "=== END AUDIT ==="
  '';
in
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";

  security.doas.enable = true;
  security.doas.extraRules = [{
    users = [ user.name ];
    keepEnv = true;
    persist = true;
  }];
  security.sudo.enable = false;

  programs.dconf.enable = true;

  users.users.${user.name} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "scanner" "lp" ];
  };

  environment.systemPackages = with pkgs; [
    git vim curl wget htop tree
    ripgrep fd fzf bat jq
    rsync mtr dnsutils
    strace lsof tcpdump
    smartmontools nvme-cli lm_sensors
    zip unzip p7zip
    exfatprogs ntfs3g
    alejandra
    lnav
    systemAudit
  ];
}
