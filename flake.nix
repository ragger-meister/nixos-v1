{
  description = "NixOS Workstation SOTA";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    theme = import ./themes/default.nix { };
    themeLib = import ./themes/lib.nix { inherit theme; };

    user = {
      name = "anton";
      home = "/home/anton";
    };

    baseModules = [
      ./system/default.nix
      ./desktop/display-manager.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit theme themeLib user; };
        home-manager.backupFileExtension = "backup";
        home-manager.users.${user.name} = { config, pkgs, ... }: {
          imports = [
            ./user/default.nix
            ./desktop/hyprland/default.nix
          ];
        };
      }
    ];
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs theme themeLib user; };
      modules = baseModules ++ [
        ./system/hosts/workstation/default.nix
      ];
    };

    nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs theme themeLib user; };
      modules = baseModules ++ [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
        ({ pkgs, lib, ... }: {
          networking.hostName = "nixos-live";
          time.timeZone = "Europe/Madrid";
          i18n.defaultLocale = "en_US.UTF-8";
          console.keyMap = "es";
          users.users.${user.name} = {
            isNormalUser = true;
            extraGroups = [ "wheel" "networkmanager" ];
            initialPassword = "nixos";
          };
          isoImage.squashfsCompression = "gzip -Xcompression-level 1";
        })
      ];
    };
  };
}
