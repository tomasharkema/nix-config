{ flatpak, ... }:
# flatpak.lib.flatpak.wrapFlatpakLauncher "tv.plex.plexHTPC";{
# services.flatpak.enable = true;
# environment.etc = {
#   "flatpak/remotes.d/flathub.flatpakrepo".source = pkgs.fetchurl {
#     url = "https://dl.flathub.org/repo/flathub.flatpakrepo";
#     # Let this run once and you will get the hash as an error.
#     hash = "sha256-M3HdJQ5h2eFjNjAHP+/aFTzUQm9y9K+gwzc64uj+oDo=";
#   };
# };
# system.activationScripts = {
#   flathub = ''
#     /run/current-system/sw/bin/flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo -y
#     /run/current-system/sw/bin/flatpak install flathub io.missioncenter.MissionCenter -y
#   '';
# };

# }
flatpak.lib.flatpak.wrapFlatpakLauncher "tv.plex.plexHTPC"
"io.missioncenter.MissionCenter"
