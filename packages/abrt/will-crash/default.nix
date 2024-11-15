{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  openjdk,
  pkg-config,
  ruby,
  cmake,
  buildPackages,
}:
stdenv.mkDerivation rec {
  pname = "will-crash";
  version = "0.13.5";

  src = fetchFromGitHub {
    owner = "abrt";
    repo = "will-crash";
    rev = "v${version}";
    hash = "sha256-8szrbUpotGik+NyN3pKhs1vP+swmEJifCffKjzlLtGA=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    ruby
    openjdk
  ];

  buildInputs = [
    ruby
    openjdk
  ];

  preConfigure = ''
    substituteInPlace "meson.build" \
      --replace-fail "'ruby'" "'ruby-3.3'" \
      --replace-fail "vendordir = ruby.get_pkgconfig_variable('vendordir')" "vendordir = get_option('vendordir')"

    echo " option('vendordir', type : 'string', value : 'optval')" >> meson_options.txt
  '';

  mesonFlags = [
    "-Dvendordir=${placeholder "out"}"
  ];

  # prePatch = ''
  #   mv meson.build-nojava meson.build
  # '';

  meta = with lib; {
    description = "Set of crashing executables written in various languages";
    homepage = "https://github.com/abrt/will-crash";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "will-crash";
    platforms = platforms.all;
  };
}
