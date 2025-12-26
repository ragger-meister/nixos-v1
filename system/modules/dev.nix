{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    gcc
    gnumake
    pkg-config
    openssl
    openssl.dev
    nodejs
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
