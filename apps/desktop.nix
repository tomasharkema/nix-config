{
  pkgs,
  inputs,
  ...
}:
# let
#   nixgui = import (pkgs.fetchFromGitHub {
#     owner = "nix-gui";
#     repo = "nix-gui";
#     # rev = "d4e59eaecb46a74c82229a1d326839be83a1a3ed";
#     # sha256 = "1fy7y4ln63ynad5v9w4z8srb9c8j2lz67fjsf6a923czm9lh5naf";
#   });
# in
{
  imports = [
    ./gnome
  ];
}
