{
  description = "Screenix binary package for NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg:
          nixpkgs.lib.getName pkg == "screenix-bin";
      };
      screenix-bin = pkgs.callPackage ./package.nix { };
    in
    {
      packages.${system} = {
        inherit screenix-bin;
        default = screenix-bin;
      };
    };
}
