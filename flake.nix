{
  description = "Fast fork of dotacat";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils }:
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
            rev = "";
            hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };

          cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

          useFetchCargoVendor = true;

          meta = with pkgs.lib; {
            description = "Fast ANSI-colored cat, like lolcat, but faster";
            license = licenses.mit;
            mainProgram = "dotacat";
          };
        };
      });
}
