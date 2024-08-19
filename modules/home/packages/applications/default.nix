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
  options = {
    # home.favoriteAppIds = mkOption {};
  };
  config = let
    favoriteApplications = with pkgs;
      [
        {package = gnome.nautilus;}
        {package = osConfig.programs.firefox.package;}
        {package = unstable.geary;}
        {package = unstable.vscode;}
        {package = unstable.tilix;}
        # {package = config.programs.wezterm.package;}
        {package = unstable.telegram-desktop;}
        {package = osConfig.programs._1password-gui.package;}
        {package = unstable.notify-client;}
      ]
      ++ (optional pkgs.stdenv.isx86_64 {package = unstable.termius;})
      ++ [
        {id = "org.cockpit_project.CockpitClient.desktop";}
      ];

    packagesToAdd =
      lists.concatMap
      ({
        package ? null,
        id ? null,
      }:
        if package != null
        then [package]
        else [])
      favoriteApplications;

    favoriteAppIds =
      lists.concatMap
      ({
        package ? null,
        id ? null,
      }:
        if package != null
        then [(findDesktopFileBase package)]
        else [id])
      favoriteApplications;
  in
    mkIf pkgs.stdenv.isLinux {
      home = {
        packages = packagesToAdd ++ (with pkgs; [gnome.vinagre gnome.devhelp]);
        # favoriteAppIds = favoriteAppIds;
      };

      dconf.settings."org/gnome/shell".favorite-apps = favoriteAppIds;

      xdg.mimeApps.defaultApplications = {
        "application/pdf" = [(findDesktopFileBase osConfig.programs.evince.package)];
      };
    };
}
