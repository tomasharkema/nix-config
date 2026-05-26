{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf false {
    home.packages = with pkgs; [
      zotero
    ];
  };
}
