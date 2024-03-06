{
  description = "virtual environment for rime";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nurpkgs-custom.url = "github:plokid/nur-packages";
    nurpkgs-custom.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nurpkgs-custom, ... }:
    let
      overlays = [
        (final: prev: {
          nurpkgs-custom = nurpkgs-custom.packages."${prev.system}";
        })
      ];

      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
      });
    in {
      devShells = forAllSystems({ pkgs }: {
        default = pkgs.mkShell {
          packages = [
            pkgs.nurpkgs-custom.imewlconverter
            # pkgs.dotnetCorePackages.sdk_8_0
            pkgs.libime
          ];
        };    
      });
    };
}

