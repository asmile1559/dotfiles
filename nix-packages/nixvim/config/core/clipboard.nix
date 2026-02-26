{ pkgs, ... }:

{
  clipboard = {
    register = "unnamedplus";

    providers.wl-copy.enable = pkgs.stdenv.hostPlatform.isLinux;
  };
}
