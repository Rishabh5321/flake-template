{
  description = "Flake with package defined in package.nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    forAllSystems = f: nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
      f {
        inherit system;
        pkgs = import nixpkgs { inherit system; };
      }
    );
  in {
    packages = forAllSystems ({ pkgs, ... }: {
      default = pkgs.callPackage ./package.nix {};
    });

    defaultPackage = forAllSystems ({ pkgs, ... }: pkgs.callPackage ./package.nix {});

    devShells = forAllSystems ({ pkgs, ... }: {
      default = pkgs.mkShell {
        buildInputs = [ pkgs.callPackage ./package.nix {} ];
      };
    });
  };
}
