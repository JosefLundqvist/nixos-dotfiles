{
  description = "Shared NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    pi.url = "github:earendil-works/pi";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, pi, ... }:
    let
      username = "josef";
      mkHost =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username; };
          modules = [
            ./modules/nixos
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                    inherit username;
                    piPackage = pi.packages.${system}.default;
                };
                users.${username} = import ./home/josef;
              };
            }
            ./hosts/${hostname}
          ];
        };
    in
    {
      nixosConfigurations = {
        nixlab = mkHost "nixlab" "x86_64-linux";
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    };
}
