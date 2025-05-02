{
  description = "Fast fork of dotacat";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        rustPlatform = pkgs.rustPlatform;
      in {
        packages.default = rustPlatform.buildRustPackage {
          pname = "dotacat-fast";
          version = "0.4";

          src = pkgs.fetchFromGitHub {
            owner = "daveman1010221";
            repo = "dotacat-fast";
            rev = "1eeed96522cf18a1e303aeeeb597e8b943a78b9d";
            hash = "sha256-DOcLYRY829GoFJqa3fRsGfF9rdRJm6Lx1DVOKjMBQxs="; # dummy hash
          };

          cargoHash = "sha256-lX84r7hH5hFPF76ZG/9TSMDAHSSz30B99iOT7sDBXPA="; # dummy hash

          useFetchCargoVendor = true;

          meta = with pkgs.lib; {
            description = "Fast ANSI-colored cat, like lolcat, but faster";
            license = licenses.mit;
            mainProgram = "dotacat";
          };
        };
      });
}
