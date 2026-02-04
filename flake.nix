{
  description = "GTA3 Script Compiler/Decompiler";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "gta3sc";
          version = "1.0";
          src = self;

          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config
          ];

          buildInputs = with pkgs; [
            gcc
          ];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
          ];

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin
            cp gta3sc $out/bin/
            mkdir -p $out/share/gta3sc
            cp -r ${self}/config $out/share/gta3sc/

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "A native script compiler/decompiler for GTA 3D Universe";
            homepage = "https://github.com/thelink2012/gta3sc";
            license = licenses.mit;
            platforms = [ "x86_64-linux" "aarch64-linux" ];
            maintainers = [ ];
          };
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.default ];

          packages = with pkgs; [
            cmake
            gdb
            valgrind
            lit
            python3
          ];

          shellHook = ''
            echo "gta3sc development environment loaded"
          '';
        };
      }
    );
}
