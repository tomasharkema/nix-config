# GNU nano 7.2                                       org.gnome.Epiphany.WebApp_b336fc558722224b7ffe98607055d55f0fe52450.desktop                                       Modified
# [Desktop Entry]
# Exec=epiphany --application-mode --profile=/home/tomas/.local/share/org.gnome.Epiphany.WebApp_b336fc558722224b7ffe98607055d55f0fe52450 https://web.whatsapp.com/
# StartupNotify=true
# Terminal=false
# Type=Application
# Categories=GNOME;GTK;
# StartupWMClass=org.gnome.Epiphany.WebApp_b336fc558722224b7ffe98607055d55f0fe52450
# X-Purism-FormFactor=Workstation;Mobile;
# Name=WhatsApp
# Icon=/home/tomas/.local/share/xdg-desktop-portal/icons/192x192/org.gnome.Epiphany.WebApp_b336fc558722224b7ffe98607055d55f0fe52450.png
# {lib, ...}: rec {
#   mkWebapp = pkgs: name: desktopName: url: icon: let
#     hash = builtins.hashString "md5" "${name}_${url}";
#     webName = "org.gnome.Epiphany.WebApp_${hash}";
#   in
#     pkgs.makeDesktopItem {
#       name = "${name}_${hash}";
#       desktopName = desktopName;
#       exec = ''
#         ${lib.getExe pkgs.gnome.epiphany} --application-mode --profile=/home/tomas/.local/share/${webName} ${url}
#       '';
#       startupNotify = "true";
#       terminal = "false";
#       type = "Application";
#       startupWMClass = webName;
#       mimetype = "x-scheme-handler/org-protocol";
#       icon = icon;
#     };
# }
# https://my.zerotier.com/network/***REMOVED***
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  nixosWebapp = {
    name = "nixos-search";
    desktopName = "NixOS Search";
    url = "https://search.nixos.org";
    # icon = pkgs.fetchurl {
    #   url = "https://upload.wikimedia.org/wikipedia/commons/5/5e/WhatsApp_icon.png";
    #   hash = "sha256-va3j/EsdUVRvekWFPAb3O3Os7wOtz1xZhzKvZAvbJXM=";
    # };
    # icons = pkgs.fetchurl {
    #   url = "https://upload.wikimedia.org/wikipedia/commons/5/5e/WhatsApp_icon.png";
    #   hash = "sha256-va3j/EsdUVRvekWFPAb3O3Os7wOtz1xZhzKvZAvbJXM=";
    # };
    icon = "${pkgs.nixos-icons}/icons/hicolor/1024x1024/app/nix-snowflake-white.png";
  };
in {
  options.apps.gui.webapp = {
    apps = mkOption {
      type = with types;
        listOf (submodule {
          options = {
            name = mkOption {type = str;};
            desktopName = mkOption {type = str;};
            url = mkOption {type = str;};
            icon = mkOption {type = path;};
          };
        });

      description = "webapps";
      default = [nixosWebapp];
    };
  };

  # config = let
  #   apps = lib.lists.forEach config.apps.gui.webapp.apps ({
  #     name,
  #     url,
  #     desktopName,
  #     icon,
  #   }: let
  #     hash = builtins.hashString "md5" "${name}_${url}";
  #     webName = "org.gnome.Epiphany.WebApp_${hash}";
  #     path = "/home/tomas/.local/share/${webName}";
  #   in
  #     pkgs.makeDesktopItem {
  #       name = "${name}_${hash}";
  #       desktopName = desktopName;
  #       exec = "${pkgs.gnome.epiphany}/bin/epiphany --application-mode --profile=${path} ${url}";
  #       startupNotify = true;
  #       terminal = false;
  #       startupWMClass = webName;
  #       mimeTypes = ["x-scheme-handler/org-protocol"];
  #       icon = icon;
  #     });
  # in {
  #   environment.systemPackages = apps;
  # };

  config = let
    folders =
      lib.lists.forEach config.apps.gui.webapp.apps
      ({
          name,
          url,
          desktopName,
          icon,
        } @ attr: (rec {
            hash = builtins.hashString "md5" "${name}_${url}";
            webName = "org.gnome.Epiphany.WebApp_${hash}";
            path = "/home/tomas/.local/share/${webName}";
          }
          // attr));
    # apps = lib.lists.forEach folders ({
    #   name,
    #   hash,
    #   desktopName,
    #   path,
    #   url,
    #   icon,
    #   webName,
    # }:
    #   pkgs.makeDesktopItem {
    #     name = "${name}_${hash}";
    #     desktopName = desktopName;
    #     exec = "${pkgs.gnome.epiphany}/bin/epiphany --application-mode --profile=${path} ${url}";
    #     startupNotify = true;
    #     terminal = false;
    #     startupWMClass = webName;
    #     mimeTypes = ["x-scheme-handler/org-protocol"];
    #     icon = icon;
    #   });
  in
    mkIf pkgs.stdenv.isLinux {
      systemd.user.tmpfiles.rules =
        lib.lists.forEach folders ({path, ...}: "d ${path} 0777 tomas tomas -");
      # environment.systemPackages = apps;
      # home.file = builtins.listToAttrs (lib.lists.forEach apps (attr: {
      #   name = attr.name;
      #   value = {
      #     source = attr;
      #   };
      # }));

      # systemd.user.tmpfiles.rules = [
      # "d "
      # ];

      xdg.desktopEntries = builtins.listToAttrs (lib.lists.forEach folders
        ({
          name,
          hash,
          desktopName,
          path,
          url,
          icon,
          webName,
        }: {
          name = "${name}_${hash}";
          value = {
            # name = "${name}_${hash}";
            # desktopName = desktopName;
            name = desktopName;
            exec = "${pkgs.epiphany}/bin/epiphany --application-mode --profile=${path} ${url}";
            startupNotify = true;
            terminal = false;
            # startupWMClass = webName;
            # mimeType = ["x-scheme-handler/org-protocol"];
            icon = icon;
          };
        }));
    };
}
