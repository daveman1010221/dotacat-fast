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
            rev = "d24e9a474751e61546144a5a4b34768c368002ef";
            hash = "sha256-CZu8s+OZON4sXiD/0IqrIBHXhVtfQNQtHPzaqWK5hSg=";
          };

          cargoHash = "sha256-lX84r7hH5hFPF76ZG/9TSMDAHSSz30B99iOT7sDBXPA=";

          useFetchCargoVendor = true;

          meta = with pkgs.lib; {
            description = "Fast ANSI-colored cat, like lolcat, but faster";
            license = licenses.mit;
            mainProgram = "dotacat";
          };
        };
      });
}
