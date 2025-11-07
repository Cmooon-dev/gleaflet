{
  description = "Flake utils demo";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages =
            with pkgs;
            [
              gleam
              erlang
              rebar3

              bun
              typescript-language-server

              fish
            ]
            ++ pkgs.lib.optionals (pkgs.stdenv.isLinux) [ inotify-tools ];

          shellHook = ''
            exec fish
          '';
        };
      }
    );
}
