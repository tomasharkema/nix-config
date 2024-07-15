{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with inputs.home-manager.lib.hm.gvariant;
with lib; let
  # readIniValue = path: key:
  #   builtins.readFile (pkgs.runCommand "ini-read-${builtins.hashString "sha256" path}-${key}" ''
  #     ${pkgs.initool}/bin/initool get ${path} ${key}
  #   '');
  #   idForApplication = ps: (readIniValue "${ps}/share/applications/${ps.pname}.desktop" "");
  findDesktopFile = ps:
    builtins.baseNameOf (builtins.readFile (pkgs.runCommand "calculate-desktop-${ps.pname}" {} ''

      FILEPATH="${ps}"

      echo "find desktop in $FILEPATH"

      PATH_MATCHES="$(find "$FILEPATH" -name '*.desktop')"

      for f in $PATH_MATCHES;
      do
        echo "considering $f"
        grep "NoDisplay=true" $f > /dev/null && continue

        echo $f
        echo "$f" | tr -d '\n' > $out
        continue
      done

      if [ ! -f "$out" ]; then
        echo "NO DESKTOP"
        exit 1
      fi

    ''));
in {
  config = {
    dconf.settings."org/gnome/shell".favorite-apps = (
      [
        # "org.kde.index.desktop"
        # "pcmanfm.desktop"
        (findDesktopFile pkgs.gnome.nautilus)
        # "org.gnome.Nautilus.desktop"
        # "firefox.desktop"

        (findDesktopFile pkgs.firefox)
        # "org.gnome.Console.desktop"

        (findDesktopFile pkgs.vscode)

        (findDesktopFile pkgs.wezterm)

        (findDesktopFile pkgs.tilix)

        (findDesktopFile pkgs.telegram-desktop)

        (findDesktopFile pkgs.spotify)
      ]
      # ++ (optional pkgs.stdenv.isx86_64 "kitty.desktop")
      # ++ (optional (!pkgs.stdenv.isx86_64) "com.gexperts.Tilix.desktop")
      # ++ ["com.gexperts.Tilix.desktop"]
      ++ [
        # "code.desktop"
        "org.cockpit_project.CockpitClient.desktop"
        # "org.gnome.Epiphany.WebApp_b336fc558722224b7ffe98607055d55f0fe52450.desktop"
      ]
    );
  };
}
