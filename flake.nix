{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    qmkfmt-src = {
      url = "github:rcorre/qmkfmt?ref=v0.2.0";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      qmkfmt-src,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        qmkfmt = pkgs.rustPlatform.buildRustPackage {
          pname = "qmkfmt";
          version = "v0.2.0";
          src = qmkfmt-src;
          cargoHash = "sha256-jSrGrYCJxqgp7GvcWZPGriJ5hw+Qfm9K/Po3Ay6WyzI=";
          doCheck = false;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            qmk
            qmkfmt
            dos2unix
          ];
        };
      }
    );
}
