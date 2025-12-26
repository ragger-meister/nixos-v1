{ config, pkgs, ... }:

{
  security.polkit.enable = true;
  security.apparmor.enable = true;
  services.fail2ban.enable = true;

  boot.kernel.sysctl = {
    "kernel.sysrq" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.all.log_martians" = 1;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.ip_forward" = 0;
    "net.ipv6.conf.all.forwarding" = 0;
    "kernel.randomize_va_space" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.yama.ptrace_scope" = 1;
    "kernel.unprivileged_bpf_disabled" = 1;
  };

  security.auditd.enable = true;
  security.audit.enable = true;
  security.audit.rules = [
    "-a always,exit -F arch=b64 -S execve -k exec"
    "-w /etc/passwd -p wa -k identity"
    "-w /etc/shadow -p wa -k identity"
  ];

  environment.systemPackages = with pkgs; [
    lynis
    chkrootkit
    age
    sops
    ssh-to-age
    passage
    cryptsetup
  ];
}
