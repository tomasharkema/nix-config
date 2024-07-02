{
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "nixos-hosts";

  src = fetchFromGitHub {
    owner = "jakehamilton";
    repo = "config";
    rev = "957743f098902c3eb03f60b1e9aca340935b12a4";
    hash = "sha256-JgD2QZ79f/UrMjm+gmEfbMwFwAZtDb2NwxLjxFLrAZM=";
  };

  installPhase = ''
    mkdir -p $out
    mv packages/nixos-hosts/ $out
    ls -la $out
  '';
}
