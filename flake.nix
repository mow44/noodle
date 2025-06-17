{
  description = "uxn noodle";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        uxn = pkgs.uxn;
      in
      {
        packages = {
          default =
            with pkgs;
            stdenv.mkDerivation {
              name = "noodle";

              nativeBuildInputs = [
                uxn
              ];

              src = self;

              buildPhase = ''
                uxnasm noodle.tal noodle.rom
              '';

              installPhase = ''
                mkdir -p $out/bin
                cp noodle.rom $out/bin
              '';
            };
        };
      }
    );
}
