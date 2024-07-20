{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.augeas = {
    enable = mkEnableOption "augeas";

    overrides = mkOption {};
  };

  config = let
    augFile = pkgs.writeFile "modifications.aug" ''

    '';
  in {
    home.activation = {
      augeas = ''
        echo "augeas"
      '';
    };
  };
}
