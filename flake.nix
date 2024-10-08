{
  description = "utzvim: a nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-root.url = "github:srid/flake-root";
  };

  outputs = {
    nixvim,
    flake-parts,
    treefmt-nix,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-root.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        config,
        inputs',
        ...
      }: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimModule = {
          inherit pkgs;
          module = import ./config; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            inherit (inputs') yazi;
          };
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
        };

        packages = {
          # Lets you run `nix run .` to start nixvim
          default = nvim;
          watch = pkgs.writeShellApplication {
            name = "watch";
            runtimeInputs = with pkgs; [watchexec];
            text = ''
              watchexec -- nix flake check
            '';
          };
          dogfood = pkgs.writeShellApplication {
            name = "dogfood";
            text = ''
              while :; do nix run; done
            '';
          };
        };

        treefmt.config = {
          inherit (config.flake-root) projectRootFile;
          settings = {
            excludes = [
              ".git"
              "*.log"
            ];
          };
          programs.alejandra.enable = true;
        };

        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              config.treefmt.build.wrapper
            ];

            packages = [
              config.packages.watch
              config.packages.dogfood
              pkgs.gum
            ];

            shellHook = ''
              gum format <<EOF
                # Welcome

                ## Commands

                - \`watch\`: watch for changes and run the checks
                - \`dogfood\`: run utzvim in a loop for rapid development
              EOF
              echo
            '';
          };
        };
      };
    };
}
