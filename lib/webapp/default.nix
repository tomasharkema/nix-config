#  GNU nano 7.2                                       org.gnome.Epiphany.WebApp_b336fc558722224b7ffe98607055d55f0fe52450.desktop                                       Modified
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
{lib, ...}: rec {
  mkWebapp = pkgs: name: desktopName: url: icon: let
    hash = builtins.hashString "md5" "${name}_${url}";
    webName = "org.gnome.Epiphany.WebApp_${hash}";
  in
    pkgs.makeDesktopItem {
      name = "${name}_${hash}";
      desktopName = desktopName;
      exec = ''
        ${lib.getExe pkgs.gnome.epiphany} --application-mode --profile=/home/tomas/.local/share/${webName} ${url}
      '';
      startupNotify = "true";
      terminal = "false";
      type = "Application";
      startupWMClass = webName;
      mimetype = "x-scheme-handler/org-protocol";
      icon = icon;
    };
}
