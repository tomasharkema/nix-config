{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  gnome-themes-extra,
  gtk-engine-murrine,
  # python3,
  sassc,
  nix-update-script,
  accents ? ["blue"],
  size ? "standard",
  tweaks ? [],
  variant ? "frappe",
  inputs,
  system,
  python3,
}: let
  # python3 = inputs.unstable.legacyPackages."${system}".python3;
  validAccents = ["blue" "flamingo" "green" "lavender" "maroon" "mauve" "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow"];
  validSizes = ["standard" "compact"];
  validTweaks = ["black" "rimless" "normal" "float"];
  validVariants = ["latte" "frappe" "macchiato" "mocha"];

  pname = "catppuccin-gtk";

  celloidSrc = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Colloid-gtk-theme";
    rev = "1cf28eac2023b336daf6b415d0a498a69d5fea56";
    hash = "sha256-h/laiimojfVii3pmVhmjM6ImNnTI02m/XtArdy2RVK4=";
  };
in
  lib.checkListOfEnum "${pname}: theme accent" validAccents accents
  lib.checkListOfEnum "${pname}: color variant"
  validVariants [variant]
  lib.checkListOfEnum "${pname}: size variant"
  validSizes [size]
  lib.checkListOfEnum "${pname}: tweaks"
  validTweaks
  tweaks
  stdenvNoCC.mkDerivation rec {
    inherit pname;
    version = "0.7.4";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "gtk";
      rev = "v${version}";
      hash = "sha256-RFhahwiBTsjeRW71JkAveOHO70O6SbTZhUEvq8oMQ4Y=";
    };

    nativeBuildInputs = [gtk3 sassc];

    # patches = [
    # ./colloid-src-git-reset.patch
    # ];

    buildInputs = [
      gnome-themes-extra
      (python3.withPackages (ps: [ps.catppuccin]))
    ];

    propagatedUserEnvPkgs = [gtk-engine-murrine];

    postUnpack = ''
      rm -rf source/colloid
      cp -r ${celloidSrc} source/colloid
      chmod -R +w source/colloid
    '';

    postPatch = ''
      patchShebangs --build colloid/install.sh colloid/build.sh
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      cp -r colloid colloid-base
      mkdir -p $out/share/themes
      export HOME=$(mktemp -d)

      python3 install.py ${variant} \
        ${lib.optionalString (accents != []) "--accent " + builtins.toString accents} \
        ${lib.optionalString (size != []) "--size " + size} \
        ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks} \
        --dest $out/share/themes

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script {};

    meta = with lib; {
      description = "Soothing pastel theme for GTK";
      homepage = "https://github.com/catppuccin/gtk";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [fufexan dixslyf];
    };
  }
