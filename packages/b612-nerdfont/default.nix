{
  nerd-font-patcher,
  stdenvNoCC,
  b612,
}: let
  font = b612;
in
  stdenvNoCC.mkDerivation {
    name = "${font.name}-nerd-font-patched";
    src = font;
    nativeBuildInputs = [nerd-font-patcher];
    buildPhase = ''
      tree

      find \( -name \*.ttf -o -name \*.otf \) -execdir nerd-font-patcher -c {} \;

      tree
    '';

    installPhase = ''
      cp -a . $out
    '';
  }
