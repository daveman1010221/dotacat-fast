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
            rev = "10735dadf60ee13157ff2a7c00cdf04eaae28b89";
            hash = "sha256-x/EqLrhddyaS7NeENoO6xvcJbpdlgZQ1OogKOqo+Tjo=";
          };

          cargoHash = "sha256-zA5VnMj+iyRas9dYVb5NwlPgMUNKSRwnlpK3zp5i+ls=";

          useFetchCargoVendor = true;

          meta = with pkgs.lib; {
            description = "Fast ANSI-colored cat, like lolcat, but faster";
            license = licenses.mit;
            mainProgram = "dotacat";
          };
        };
      });
}
