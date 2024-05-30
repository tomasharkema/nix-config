{ channels, self, ... }:
final: prev: {
  # gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
  #   mutter = gnomePrev.mutter.overrideAttrs (old: {
  #     src = fetchTarball {
  #       url =
  #         "https://gitlab.gnome.org/vanvugt/mutter/-/archive/triple-buffering-v4-46/mutter-triple-buffering-v4-46.tar.gz";
  #       sha256 = "sha256:1fqss0837k3sc7hdixcgy6w1j73jdc57cglqxdc644a97v5khnr3";
  #     };
  #   });
  # });
  # dconf = channels.unstable.dconf;
  # flatpak = channels.unstable.flatpak;

  mpv = prev.mpv.override { scripts = [ final.mpvScripts.mpris ]; };

  mpv-unwrapped = prev.mpv-unwrapped.override { ffmpeg = prev.ffmpeg-full; };

  spotifyd = prev.spotifyd.override { withMpris = true; };

  shairport-sync = prev.shairport-sync.override { enableAirplay2 = true; };
}
