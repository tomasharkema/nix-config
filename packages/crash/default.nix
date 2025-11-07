{
  lib,
  stdenv,
  fetchFromGitHub,
  gdb,
  pkg-config,
  wget,
  fetchurl,
  gmp,
  mpfr,
  texinfo,
  bison,
  zlib,
}: let
  gdbTar = fetchurl {
    url = "http://ftp.gnu.org/gnu/gdb/gdb-16.2.tar.gz";
    sha256 = "1y1p59sn3a9fws4cnd9j17nmp97sir0v0d3x5rssr01j0d5dmhdx";
  };
in
  stdenv.mkDerivation rec {
    pname = "crash";
    version = "9.0.0";

    src = fetchFromGitHub {
      owner = "crash-utility";
      repo = "crash";
      rev = version;
      hash = "sha256-GSqlaBa+rSzxE2wgXTs542K9gUFtnvA14XeC6Auo4NA=";
    };

    postPatch = ''
      # substituteInPlace Makefile --replace-fail "/usr/bin/wget" "${wget}/bin/wget" \
      #   --replace-fail " wget " " ${wget}/bin/wget "
      cp ${gdbTar} ./gdb-16.2.tar.gz
    '';

    nativeBuildInputs = [pkg-config];
    buildInputs = [
      gdb
      gmp
      mpfr
      texinfo
      bison
      zlib
    ];

    meta = {
      description = "Linux kernel crash utility  NOTE: The github PRs are not accepted, please subscribe to mail list via https://lists.crash-utility.osci.io/admin/lists/devel.lists.crash-utility.osci.io/ for contribution and discussion. Or post your patch/issue to mail list: devel@lists.crash-utility.osci.io";
      homepage = "https://github.com/crash-utility/crash";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "crash";
      platforms = lib.platforms.all;
    };
  }
