{
    # where to fetch nix stuff -- do not touch
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
        systems.url = "github:nix-systems/default";
        flake-utils = {
        url = "github:numtide/flake-utils";
        inputs = { systems.follows = "systems"; };
        };
        devenv = {
        url = "github:cachix/devenv";
        inputs = { nixpkgs.follows = "nixpkgs"; };
        };
        fenix = {
        url = "github:nix-community/fenix";
        inputs = { nixpkgs.follows = "nixpkgs"; };
        };
    };

    # where to fetch nix stuff -- do not touch
    nixConfig = {
        extra-trusted-public-keys =
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
        extra-substituters = "https://devenv.cachix.org";
    };

    # 
    outputs = { self, nixpkgs, devenv, systems, flake-utils, fenix, ... }@inputs:
        with builtins; flake-utils.lib.eachDefaultSystem (system:
        let
            pkgs = nixpkgs.legacyPackages.${system};


            nativeBuildInputs = with pkgs; [
            nodejs_20
            yarn
            gnumake
            gitFull
            sqlite
            docker-compose
            ];

            devInputs =  nativeBuildInputs;

            lib = pkgs.lib;
        in {
            devShells.default = devenv.lib.mkShell {
            inherit inputs pkgs;

            modules = [{
                packages = devInputs ++ [ pkgs.python310 pkgs.openapi-generator-cli];

                enterShell = ''
                export WEBKIT_DISABLE_COMPOSITING_MODE=1

                '';

                languages.javascript = {
                enable = true;
                package = pkgs.nodejs_20;
                corepack.enable = true;
                npm.install.enable = false;
                };
            }];
            };
        });
}
