{
  description = "uxn noodle";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          default =
            with pkgs;
            stdenv.mkDerivation {
              name = "noodle";

              nativeBuildInputs = with pkgs; [
                uxn
              ];

              src = pkgs.fetchFromSourcehut {
                owner = "~rabbits";
                repo = "noodle";
                rev = "403f9ab8c68d91aae188d9546be76a8cf803ccc6";
                hash = "sha256-rBMhDzaCqSVZCssddDA8GOeZAR893u7pBa0VP3cwEW4="; # lib.fakeHash;
              };

              patchPhase = ''
                substituteInPlace src/manifest.tal \
                --replace ".theme" "/home/a/.config/uxn/theme"
              '';

              buildPhase = ''
                uxnasm src/noodle.tal noodle.rom
              '';

              installPhase = ''
                mkdir -p $out/bin
                cp noodle.rom $out/bin
                cp src/manifest.tal $out/bin
              '';
            };
        };
      }
    );
}
