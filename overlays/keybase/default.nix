{
  channels,
  # pkgs,
  # requireFile,
  # fetchFromGitHub,
  ...
}: final: prev: {
  keybase = prev.keybase.overrideAttrs (old: rec {
    version = "6.2.5";
    src = prev.fetchFromGitHub {
      owner = "keybase";
      repo = "client";
      rev = "v${version}";
      hash = "sha256-z7vpCUK+NU7xU9sNBlQnSy9sjXD7/m8jSRKfJAgyyN8=";
    };
  });
}
