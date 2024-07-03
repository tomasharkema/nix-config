{
  nerd-font-patcher,
  stdenv,
  b612,
  tree,
}: let
  font = b612;
in
  stdenv.mkDerivation {
    name = "${font.name}-nerd-font-patched";
    src = font;
    nativeBuildInputs = [nerd-font-patcher tree];
    buildPhase = ''
      tree

      find \( -name \*.ttf -o -name \*.otf \) -execdir nerd-font-patcher -c {} \;

      tree
    '';

    installPhase = ''
      ls -la
      tree
      cp -a . $out
    '';
  }
