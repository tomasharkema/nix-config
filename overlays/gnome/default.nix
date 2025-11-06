{
  channels,
  self,
  ...
}: final: prev: {
  # gnome-keyring = prev.gnome-keyring.overrideAttrs (prev: {
  #   postFixup =
  #     prev.postFixup
  #     + ''
  #       rm -rf $out/etc/xdg/autostart/gnome-keyring-ssh.desktop
  #     '';
  # });
  # gvdb = self.packages."${prev.system}".gvdb;
  # gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {

  # mutter = prev.mutter.overrideAttrs (oldAttrs: {
  #   # GNOME dynamic triple buffering (huge performance improvement)
  #   # See https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441
  #   src = final.fetchFromGitLab {
  #     domain = "gitlab.gnome.org";
  #     owner = "vanvugt";
  #     repo = "mutter";
  #     rev = "triple-buffering-v4-47";
  #     hash = "sha256-ajxm+EDgLYeqPBPCrgmwP+FxXab1D7y8WKDQdR95wLI=";
  #   };

  #   preConfigure = let
  #     gvdb = final.fetchFromGitLab {
  #       domain = "gitlab.gnome.org";
  #       owner = "GNOME";
  #       repo = "gvdb";
  #       rev = "2b42fc75f09dbe1cd1057580b5782b08f2dcb400";
  #       hash = "sha256-CIdEwRbtxWCwgTb5HYHrixXi+G+qeE1APRaUeka3NWk=";
  #     };
  #   in ''
  #     cp -a "${gvdb}" ./subprojects/gvdb
  #   '';
  # });
  # dconf = prev.dconf;
  # flatpak = prev.flatpak;

  # GNOME 46: triple-buffering-v4-46

  # gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {

  # });

  # mutter = prev.mutter.overrideAttrs (old: rec {
  #   patches = [
  #     ./triple-buffer.patch
  #     (prev.fetchpatch {
  #       url = "https://aur.archlinux.org/cgit/aur.git/plain/xwayland-scaling.patch?h=mutter-xwayland-scaling";
  #       sha256 = "sha256-deoWaseI+CnH0aHUWm6YFoD+PRVsFg3zn3wVy4kIiUE=";
  #     })
  #   ];
  # });

  # mpv = prev.mpv.override {
  #   scripts = with prev.mpvScripts; [
  #     mpris
  #     # youtube-upnext
  #     simple-mpv-webui
  #     mpv-playlistmanager
  #     mpv-cheatsheet
  #     mpv-notify-send
  #     mpris
  #     # youtube-upnext
  #     simple-mpv-webui
  #     mpv-playlistmanager
  #     mpv-notify-send
  #     mpv-cheatsheet
  #     uosc
  #     memo
  #   ];
  #   # youtubeSupport = true;
  # };

  spotifyd = prev.spotifyd.override {withMpris = true;};

  shairport-sync = prev.shairport-sync.override {enableAirplay2 = true;};

  # libgda = prev.libgda.overrideAttrs (old: {
  #   env.NIX_CFLAGS_COMPILE = "";
  # });
}
