{
  channels,
  self,
  ...
}: final: prev: {
  gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
    mutter = gnomePrev.mutter.overrideAttrs (old: {
      src = fetchTarball {
        url = "https://gitlab.gnome.org/vanvugt/mutter/-/archive/triple-buffering-v4-45/mutter-triple-buffering-v4-45.tar.gz";
        sha256 = "sha256:1327y1hbqc057ljfvj1wxbzbycs3r55011324fj6l1z5cgj74cwv";
      };
    });
  });
}
