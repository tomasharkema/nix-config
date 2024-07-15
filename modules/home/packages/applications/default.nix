{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with inputs.home-manager.lib.hm.gvariant;
with lib;
with lib.custom; let
  # readIniValue = path: key:
  #   builtins.readFile (pkgs.runCommand "ini-read-${builtins.hashString "sha256" path}-${key}" ''
  #     ${pkgs.initool}/bin/initool get ${path} ${key}
  #   '');
  #   idForApplication = ps: (readIniValue "${ps}/share/applications/${ps.pname}.desktop" "");
  findDesktopFile = ps: (builtins.readFile (pkgs.runCommand "calculate-desktop-${ps.pname}" {} ''

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
  findDesktopFileBase = ps: builtins.baseNameOf (findDesktopFile ps);
in {
  options.autostart = {
    programs = mkOpt (types.listOf types.package) [] "Autostart programs";
  };

  config = {
    home.file = builtins.listToAttrs (map (pkg: {
        name = ".config/autostart/" + pkg.pname + ".desktop";
        value =
          if pkg ? desktopItem
          then {
            # Application has a desktopItem entry.
            # Assume that it was made with makeDesktopEntry, which exposes a
            # text attribute with the contents of the .desktop file
            text = pkg.desktopItem.text;
          }
          else {
            # Application does *not* have a desktopItem entry. Try to find a
            # matching .desktop name in /share/apaplications
            source = findDesktopFile pkg;
          };
      })
      config.autostart.programs);

    dconf.settings."org/gnome/shell".favorite-apps = (
      [
        # "org.kde.index.desktop"
        # "pcmanfm.desktop"
        (findDesktopFileBase pkgs.gnome.nautilus)
        # "org.gnome.Nautilus.desktop"
        # "firefox.desktop"

        (findDesktopFileBase pkgs.firefox)
        # "org.gnome.Console.desktop"

        (findDesktopFileBase pkgs.vscode)

        (findDesktopFileBase pkgs.wezterm)

        (findDesktopFileBase pkgs.tilix)
        (findDesktopFileBase pkgs.kitty)

        (findDesktopFileBase pkgs.telegram-desktop)

        (findDesktopFileBase pkgs.spotify)
        (findDesktopFileBase pkgs._1password-gui)
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
