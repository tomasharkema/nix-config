{
  channels,
  disko,
  self,
  inputs,
  lib,
  ...
}: final: prev: let
  # overridePkgCheckVersionSnapshot = name: version: pkg: (
  #   let
  #     pkgVersion = prev."${name}".version;
  #   in
  #     if (pkgVersion == version)
  #     then pkg
  #     else (builtins.throw "nixpkgs' upstream for ${name} has been updated to ${pkgVersion}. (yours is at ${pkg.version} with snapshot ${version})")
  # );
  checkUpdatedUpsteam = pkg: oldVersion: v: (lib.throwIfNot (pkg.version == oldVersion) "${pkg.pname} version ${pkg.version} != ${oldVersion} upstream is updated!" v);

  system' = final.stdenv.hostPlatform.system;
in rec {
  kdump-utils = prev.custom.kdump-utils;
  makedumpfile = prev.custom.makedumpfile;

  libfoundry = prev.custom.libfoundry;
  manuals = prev.custom.manuals;
  libcec = prev.libcec.override {withLibraspberrypi = true;};

  openldap = prev.openldap.overrideAttrs {
    doCheck = !final.stdenv.buildPlatform.isi686;
    # dontCheck = true;
  };

  systemdUkify = prev.systemdUkify.overrideAttrs ({
    buildInputs,
    postPatch,
    mesonFlags,
    ...
  }: let
    ukifyPython = prev.python3Packages.python.withPackages (ps: with ps; [pefile]);

    # When cross-compiling the host python is not executable on the build machine,
    # so meson cannot probe it; substitute a build-runnable env with the same
    # module set so the check still validates that pefile is packageable.
    ukifyPythonForMeson =
      if prev.stdenv.buildPlatform.canExecute prev.stdenv.hostPlatform
      then ukifyPython
      else prev.buildPackages.python3Packages.python.withPackages (ps: with ps; [pefile]);

    ukifyNativeFile = prev.writeText "ukify-native-file.ini" ''
      [binaries]
      python3-ukify = '${ukifyPythonForMeson.interpreter}'
    '';
  in {
    # nativeBuildInputs = nativeBuildInputs + [];
    buildInputs =
      buildInputs
      ++ [
        ukifyPython
      ];

    postPatch =
      postPatch
      + ''
        # Since v260 meson hard-requires the pefile module in the python3 it finds
        # on PATH (systemd/systemd@582d499e32e7). That is the build-time templating
        # python. Look up the runtime interpreter via a dedicated find_program()
        # name supplied through a native machine file, then pass its path to
        # find_installation() so the pefile probe runs against the interpreter
        # that actually ships in ukify's shebang (or, when cross-compiling, a
        # build-runnable env with the same module set).
        substituteInPlace meson.build \
          --replace-fail \
          "want_ukify = pymod.find_installation('python3', required: get_option('ukify'), modules : ['pefile']).found()" \
          "want_ukify = pymod.find_installation(find_program('python3-ukify', native : true, required : get_option('ukify')).full_path(), required : get_option('ukify'), modules : ['pefile']).found()"
      '';

    mesonFlags = mesonFlags ++ ["--native-file=${ukifyNativeFile}"];
  });

  synology-drive-client = checkUpdatedUpsteam prev.synology-drive-client "4.0.2-17889" prev.synology-drive-client.overrideAttrs ({buildInputs ? [], ...}: {
    buildInputs = buildInputs ++ [prev.qt5.qtwayland];
  });

  atools = prev.custom.atools;

  ipmiview = checkUpdatedUpsteam prev.ipmiview "2.21.0" prev.ipmiview.overrideAttrs (old: {
    src = prev.fetchurl {
      url = "https://www.supermicro.com/Bios/sw_download/960/IPMIView_2.23.0_build.250519_bundleJRE_Linux_x64.tar.gz";
      sha256 = "13d0figi3azajafnlfwc0amw3b00rmxyrmq60rixvwx4wx2h361j";
    };
    version = "2.23.0";
  });

  # nix-htop = inputs.nix-htop.packages."${prev.system}".nix-htop;

  # _389-ds-base = checkUpdatedUpsteam prev._389-ds-base "3.1.3" prev.custom._389-ds-base;

  pico-sdk = prev.pico-sdk.override {withSubmodules = true;};

  hopper = checkUpdatedUpsteam prev.hopper "5.19.4" prev.hopper.override {
    libffi_3_3 = checkUpdatedUpsteam prev.libffi_3_3 "3.3" prev.libffi_3_3.overrideAttrs (old: {
      doCheck = false;
    });
  };

  lcdproc = prev.lcdproc.overrideAttrs (old: {
    # configureFlags = ["--enable-drivers=all"];
    buildInputs = old.buildInputs ++ [prev.custom.glcd-proc-driver prev.custom.graphlcd-base];
  });

  sssd = checkUpdatedUpsteam prev.sssd "2.12.0" prev.sssd.overrideAttrs ({
    preConfigure,
    buildInputs,
    ...
  }: {
    preConfigure =
      preConfigure
      + ''
        configureFlagsArray+=("--with-passkey" "--with-sudo")
      '';
    buildInputs = buildInputs ++ [prev.libfido2];
  });

  # gpio-utils = prev.gpio-utils.overrideAttrs (old: {
  #   preConfigure = "";
  #   makeFlags = ["-C tools/gpio"];
  # });

  # __udisks = overridePkgCheckVersionSnapshot "udisks2" "" udisks2;

  # __udisks2 = prev.udisks2.overrideAttrs (old: {
  #   buildInputs =
  #     old.buildInputs
  #     ++ [
  #       prev.libiscsi
  #       prev.libconfig
  #     ];
  #   # doCheck = false;
  #   configureFlags =
  #     old.configureFlags
  #     ++ [
  #       "--enable-all-modules"
  #       "--enable-btrfs"
  #       "--enable-lvm2"
  #       "--enable-smart"
  #       # "--enable-lsm"
  #       # "--enable-iscsi"
  #     ];
  # });

  authorized-keys = self.packages."${system'}".authorized-keys;

  intel-vaapi-driver = prev.intel-vaapi-driver.override {enableHybridCodec = true;};

  # ntfy-sh = prev.ntfy-sh.overrideAttrs (old: {
  #   buildPhase = ''
  #     #   #   runHook preBuild
  #         make cli-client
  #     #   #   runHook postBuild
  #   '';

  #   # tags = ["noserver"];

  #   nativeBuildInputs = with prev; [
  #     git
  #     debianutils
  #     go
  #     # mkdocs
  #     # python3
  #     # go
  #     # python3Packages.mkdocs-material
  #     # python3Packages.mkdocs-minify-plugin
  #   ];
  # });
}
