{
  channels,
  self,
  ...
}: let
  gnomeUseUnstable = true;
in
  final: prev: {
    # gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
    gnome = channels.unstable.gnome.overrideScope' (gnomeFinal: gnomePrev: {
      mutter = gnomePrev.mutter.overrideAttrs (old: {
        #   # src = prev.pkgs.fetchgit {
        #   #   url = "https://gitlab.gnome.org/vanvugt/mutter.git";
        #   #   # GNOME 45: triple-buffering-v4-45
        #   #   rev = "triple-buffering-v4";
        #   #   # rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
        #   #   sha256 = "";
        #   # };
        #   # src = prev.pkgs.fetchFromGitLab {
        #   #   domain = "gitlab.gnome.org";
        #   #   owner = "vanvucht";
        #   #   repo = "mutter";
        #   #   rev = "triple-buffering-v4";
        #   #   sha256 = "";
        #   # };
        src = fetchTarball {
          url = "https://gitlab.gnome.org/vanvugt/mutter/-/archive/triple-buffering-v4-45/mutter-triple-buffering-v4-45.tar.gz";
          sha256 = "sha256:1327y1hbqc057ljfvj1wxbzbycs3r55011324fj6l1z5cgj74cwv";
        };
      });
    });
  }
