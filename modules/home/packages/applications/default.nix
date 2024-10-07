{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  hmd = inputs.home-manager.lib.hm.gvariant;
  # readIniValue = path: key:
  #   builtins.readFile (pkgs.runCommand "ini-read-${builtins.hashString "sha256" path}-${key}" ''
  #     ${pkgs.initool}/bin/initool get ${path} ${key}
  #   '');
  #   idForApplication = ps: (readIniValue "${ps}/share/applications/${ps.pname}.desktop" "");
  findDesktopFile = ps: (builtins.readFile (pkgs.runCommand "calculate-desktop-${ps.name}" {} ''

    FILEPATH="${ps}"

    echo "find desktop in $FILEPATH"

    PATH_MATCHES="$(find -L "$FILEPATH" -name '*.desktop')"

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
    autostart = {
      programs = lib.mkOption {
        type = lib.types.listOf (lib.types.submodule {
          options = {
            package = lib.mkOption {
              type = lib.types.nullOr lib.types.package;
              default = null;
            };
            path = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
            };
            desktopName = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
            };
          };
        });
        default = [];
        description = "Autostart programs";
      };
    };
    # home.favoriteAppIds = lib.mkOption {};
  };
  config = let
    favoriteApplications = with pkgs;
      [
        {package = nautilus;}
        # {package = google-chrome;}
        # {package = osConfig.system.build.chromium;}
        {package = osConfig.programs.firefox.package;}
        {package = geary;}
        {package = vscode;}
        {package = tilix;}
        {package = config.programs.wezterm.package;}
        {package = termius;}
        {package = telegram-desktop;}
        {package = osConfig.programs._1password-gui.package;}
      ]
      ++ [
        {id = "org.cockpit_project.CockpitClient.desktop";}
      ];

    packagesToAdd =
      lib.lists.concatMap
      ({
        package ? null,
        id ? null,
      }:
        if package != null
        then [package]
        else [])
      favoriteApplications;

    favoriteAppIds =
      lib.lists.concatMap
      ({
        package ? null,
        id ? null,
      }:
        if package != null
        then [(findDesktopFileBase package)]
        else [id])
      favoriteApplications;
  in
    lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable) {
      home = {
        file = builtins.listToAttrs (map
          (pkg: let
            pkgName =
              if (pkg ? package && (pkg.package != null))
              then "${pkg.package.pname}.desktop"
              else pkg.desktopName;
          in {
            name = ".config/autostart/${pkgName}";
            value =
              if (pkg ? package && (pkg.package != null))
              then let
                package = pkg.package;
              in
                if package ? desktopItem
                then {
                  # Application has a desktopItem entry.
                  # Assume that it was made with makeDesktopEntry, which exposes a
                  # text attribute with the contents of the .desktop file
                  text = package.desktopItem.text;
                }
                else {
                  # Application does *not* have a desktopItem entry. Try to find a
                  # matching .desktop name in /share/apaplications
                  source = config.lib.file.mkOutOfStoreSymlink (findDesktopFile package);
                }
              else {
                source = "${pkg.path}";
              };
          })
          config.autostart.programs);
        packages = packagesToAdd ++ (with pkgs; [devhelp]);
        # favoriteAppIds = favoriteAppIds;
      };

      dconf.settings."org/gnome/shell".favorite-apps = favoriteAppIds;

      xdg.mimeApps.defaultApplications = {
        "application/pdf" = [(findDesktopFileBase osConfig.programs.evince.package)];
      };
    };
}
