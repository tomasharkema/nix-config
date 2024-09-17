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

  mutter = prev.mutter.overrideAttrs (old: rec {
    # version = "47.0";
    # src = prev.fetchurl {
    #   url = "mirror://gnome/sources/mutter/${prev.lib.versions.major version}/mutter-${version}.tar.xz";
    #   hash = "sha256-LQ6pAVCsbNAhnQB42wXW4VFNauIb+fP3QNT7A5EpAWs=";
    # };

    #   # src = prev.fetchFromGitLab {
    #   #   domain = "gitlab.gnome.org";
    #   #   owner = "vanvugt";
    #   #   repo = "mutter";
    #   #   rev = "triple-buffering-v4-46";
    #   #   hash = "sha256-C2VfW3ThPEZ37YkX7ejlyumLnWa9oij333d5c4yfZxc=";
    #   # };
    patches = [
      # (prev.fetchpatch {
      #   url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441.patch";
      #   sha256 = "sha256-2dHBiYw7i2MADYEmEx9TqvQn9exKKKnWYzsQhmrjloo=";
      # })

      # (prev.fetchpatch {
      #   url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3567.patch";
      #   sha256 = "sha256-S+uH4rJiVSyU2G+cudeh6bp2hWs1GMPE/9gaAKAWs1Q=";
      # })
      ./triple-buffer.patch
      (prev.fetchpatch {
        url = "https://aur.archlinux.org/cgit/aur.git/plain/xwayland-scaling.patch?h=mutter-xwayland-scaling";
        sha256 = "sha256-deoWaseI+CnH0aHUWm6YFoD+PRVsFg3zn3wVy4kIiUE=";
      })
    ];
  });

  mpv = prev.mpv.override {
    scripts = with prev.mpvScripts; [
      mpris
      youtube-upnext
      simple-mpv-webui
      mpv-playlistmanager
      mpv-cheatsheet
      mpv-notify-send
      mpris
      youtube-upnext
      simple-mpv-webui
      mpv-playlistmanager
      mpv-notify-send
      mpv-cheatsheet
      uosc
      memo
    ];
    youtubeSupport = true;
  };

  spotifyd = prev.spotifyd.override {withMpris = true;};

  shairport-sync = prev.shairport-sync.override {enableAirplay2 = true;};

  libgda = prev.libgda.overrideAttrs (old: {
    env.NIX_CFLAGS_COMPILE = "";
  });
}
