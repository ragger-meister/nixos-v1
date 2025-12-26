{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/boot.nix
    ./modules/base.nix
    ./modules/network.nix
    ./modules/security.nix
    ./modules/services.nix
    ./modules/dev.nix
    ./modules/maintenance.nix
  ];
}
