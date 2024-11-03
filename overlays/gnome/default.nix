{
  channels,
  self,
  ...
}: final: prev: {
  # gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
  #   mutter = gnomePrev.mutter.overrideAttrs (old: {
  #     src = fetchTarball {
  #       url =
  #         "https://gitlab.gnome.org/vanvugt/mutter/-/archive/triple-buffering-v4-46/mutter-triple-buffering-v4-46.tar.gz";
  #       sha256 = "sha256:1fqss0837k3sc7hdixcgy6w1j73jdc57cglqxdc644a97v5khnr3";
  #     };
  #   });
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

  libgda = prev.libgda.overrideAttrs (old: {
    env.NIX_CFLAGS_COMPILE = "";
  });
}
