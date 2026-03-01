{
  description = "Go development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            go

            gopls
            delve
            golangci-lint
            gotools
            goreleaser

            jq
            # add packages here
          ];

          GO111MODULE = "on";
          GOPATH = "<a-path>/nix/go";

          shellHook = ''
            export PATH="$GOPATH/bin:$PATH"
            echo "🐹 Go dev shell ready"
            go version 
          '';
        };
      }
    );
}
