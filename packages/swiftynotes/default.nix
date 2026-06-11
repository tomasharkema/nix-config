{
  pkgs,
  inputs,
  fetchFromGitHub,
  pkg-config,
  libadwaita,
  webkitgtk_6_0,
  gtksourceview5,
  libspelling,
  libsysprof-capture,
  pcre2,
  util-linux,
  selinuxPackages,
  fribidi,
  libthai,
  libdatrie,
  expat,
  libxdmcp,
  libdeflate,
  lerc,
  xz,
  zstd,
  libwebp,
  appstream,
  libxml2,
  sqlite,
  libpsl,
  libnghttp2,
  glibc,
  clang,
  stdenv,
}: let
  swiftix = inputs.swiftix;
  mkSwiftPackage = swiftix.lib.mkSwiftPackage {inherit pkgs;};
  swiftpm2nixHelpers = swiftix.lib.swiftpm2nixHelpers {inherit pkgs;};
in
  mkSwiftPackage rec {
    pname = "swiftynotes";
    version = "1.3.0";

    src = fetchFromGitHub {
      owner = "makoni";
      repo = "swiftynotes";
      rev = "${version}";
      hash = "sha256-ZAbqbj7xY2GLqkPDhilKSgi4hBm93etcoHn+YYyWNdI=";
    };

    swift = swiftix.packages.${stdenv.hostPlatform.system}.latest;
    swiftpmGenerated = swiftpm2nixHelpers ./nix/swift.nix;
    executableName = "swiftynotes"; # name of the executable target

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      libadwaita
      webkitgtk_6_0
      gtksourceview5
      libspelling
      libsysprof-capture
      pcre2
      util-linux.dev
      selinuxPackages.libselinux
      selinuxPackages.libsepol
      fribidi
      libthai
      libdatrie
      expat
      libxdmcp
      libdeflate
      lerc
      xz
      zstd
      libwebp
      appstream
      libxml2
      sqlite
      libpsl
      libnghttp2.dev
      # glibc.dev
      # clang
    ];

    postInstall = ''
      cp -rv .build/release/swifty-notes-gtk_SwiftyNotes.resources $out/bin/
    '';
  }
