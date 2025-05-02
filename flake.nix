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
            rev = "b35f15384dd2bbb2e6f9d4638ce9ced7a3336531";
            hash = "sha256-NPbgp94Dz1BZLI8DEUwSeHMzGV9RprCdWAtHsq5eaLs="; # dummy hash
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
