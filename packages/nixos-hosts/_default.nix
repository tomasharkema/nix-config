{pkgs, ...}:
with pkgs;
  stdenvNoCC.mkDerivation {
    name = "nixos-hosts";

    src = fetchFromGitHub {
      owner = "jakehamilton";
      repo = "config";
      rev = "a54df9f0aeee0ec5f7bc597e077cbd56e66f06f3";
      hash = "sha256-8EYS0MqMlQagURLL+FjIM9fa326FA4rj6fdd8OTNvuA=";
    };

    installPhase = ''
      mkdir -p $out
      mv packages/nixos-hosts/ $out
      ls -la $out
    '';
  }
