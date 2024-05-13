{ channels, self, ... }:
final: prev: {
  # gnome =
  #   #prev.gnome
  #   channels.unstable.gnome.overrideScope' (gnomeFinal: gnomePrev: {
  #     # mutter = gnomePrev.mutter.overrideAttrs (old: {
  #     #   src = fetchTarball {
  #     #     url = "https://gitlab.gnome.org/vanvugt/mutter/-/archive/triple-buffering-v4-45/mutter-triple-buffering-v4-45.tar.gz";
  #     #     sha256 = "sha256:1327y1hbqc057ljfvj1wxbzbycs3r55011324fj6l1z5cgj74cwv";
  #     #   };
  #     # });
  #   });
  # dconf = channels.unstable.dconf;
  # flatpak = channels.unstable.flatpak;

  mpv = prev.mpv.override { scripts = [ final.mpvScripts.mpris ]; };

  mpv-unwrapped = prev.mpv-unwrapped.override { ffmpeg = prev.ffmpeg-full; };

  spotifyd = prev.spotifyd.override { withMpris = true; };
}
