# pkgs.custom.unified-remote

{config,pkgs,lib,...}:with lib;{
  config = {
    environment.systemPackages = [
      pkgs.custom.unified-remote];
  };
}