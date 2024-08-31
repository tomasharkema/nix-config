{
  fetchFromGitHub,
  stdenv,
  python310,
  nixos-icons,
}: let
  python = python310;
in
  stdenv.mkDerivation {
    pname = "plymouth-progress";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "1deterministic";
      repo = "Plymouth-Progress-Bar";
      rev = "0062f9a1643f52f8bcc37040a3d63023a61b7197";
      hash = "sha256-Pj8G/7AaHm6FtIdt/DjqvvlPv1KZY0bGNViTUqXjjv0=";
    };

    buildInputs = [
      (python.withPackages (python-pkgs: [
        python-pkgs.pillow
      ]))
    ];

    buildPhase = ''
      mkdir -p distro-logos/dark/nixos
      cp ${nixos-icons}/share/icons/hicolor/1024x1024/apps/nix-snowflake-white.png distro-logos/dark/nixos/logo.png

      mkdir -p distro-logos/light/nixos
      cp ${nixos-icons}/share/icons/hicolor/1024x1024/apps/nix-snowflake.png distro-logos/light/nixos/logo.png

      sh build.sh
    '';

    installPhase = ''
      mkdir -p $out/share/plymouth/themes
      cp -vr build/. $out/share/plymouth/themes
    '';
  }
