{
  channels,
  disko,
  self,
  inputs,
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
  system = final.stdenv.hostPlatform.system;
in rec {
  # cudaPackages = prev.cudaPackages.overrideScope (final: prev: {
  #   cuda_cudart = prev.cuda_cudart.overrideAttrs {
  #     meta.platforms = [
  #       "aarch64-linux"
  #       "x86_64-linux"
  #       "i686-linux"
  #     ];
  #   };
  #   cuda_nvcc = prev.cuda_nvcc.overrideAttrs {
  #     meta.platforms = [
  #       "aarch64-linux"
  #       "x86_64-linux"
  #       "i686-linux"
  #     ];
  #   };
  # });
  librepods = inputs.librepods.packages.${system}.default;

  kdump-utils = prev.custom.kdump-utils;
  makedumpfile = prev.custom.makedumpfile;

  libfoundry = prev.custom.libfoundry;
  manuals = prev.custom.manuals;
  libcec = prev.libcec.override {withLibraspberrypi = true;};

  synology-drive-client = prev.synology-drive-client.overrideAttrs ({buildInputs ? [], ...}: {
    buildInputs = buildInputs ++ [prev.qt5.qtwayland];
  });
  compose2nix = inputs.compose2nix.packages."${system}".default;

  # meshtastic-fix = prev.python3Packages.meshtastic.overridePythonAttrs (old: {
  #   # postPatch = ''
  #   #   substituteInPlace pyproject.toml \
  #   #     --replace-fail "packaging = \"^24.0\"" "packaging = \"^25.0\""
  #   # '';
  #   # dependencies = [];
  #   # optional-dependencies = [];
  #   doCheck = false;
  #   nativeCheckInputs = with prev.python3Packages; [
  #     hypothesis
  #     pytestCheckHook
  #     argcomplete
  #     dotmap
  #     print-color
  #     pyqrcode
  #     wcwidth
  #   ];
  # });

  nox = inputs.nox.packages.${system}.default;
  nix-alien = inputs.nix-alien.packages.${system}.default;
  # geoclue2 = prev.geoclue2.overrideAttrs ({buildInputs, ...}: {
  #   version = prev.custom.geoclue-gpsd.version;
  #   src = prev.custom.geoclue-gpsd.src;
  #   buildInputs = buildInputs ++ prev.custom.geoclue-gpsd.buildInputs;
  # });
  # gamehub = prev.gamehub.overrideAttrs ({buildInputs, ...}: {
  #   buildInputs = buildInputs ++ [prev.libxml2];
  # });

  # platformio-core = prev.platformio-core.overrideAttrs {
  #   doCheck = false;
  #   dontCheck = true;
  # };

  # platformio = prev.platformio.overrideAttrs {
  #   doCheck = false;
  #   dontCheck = true;
  # };

  # nix-htop = inputs.nix-htop.packages."${prev.system}".nix-htop;

  # pwvucontrol = prev.custom.pwvucontrol;
  # hyprlock = inputs.hyprlock.packages."${prev.system}".hyprlock;
  gensio = prev.custom.gensio;
  # _cxxopts = prev.cxxopts.overrideAttrs (old: {
  #   # buildPhase = ''
  #   #   NIX_CFLAGS_COMPILE="-std=c++17 $NIX_CFLAGS_COMPILE"
  #   # '';
  #   buildInputs = [prev.icu74.dev];
  # });

  termbench-pro = prev.termbench-pro.overrideAttrs ({buildInputs ? [], ...}: {
    buildInputs =
      (builtins.filter (f: f.pname != "glaze") buildInputs)
      ++ [
        (prev.glaze.override {enableSSL = false;})
      ];
  });

  # nlohmann_json_3_11_3 = let
  #   version = "3.11.3";
  # in
  #   prev.nlohmann_json.overrideAttrs ({cmakeFlags, ...}: {
  #     version = version;
  #     src = prev.fetchFromGitHub {
  #       owner = "nlohmann";
  #       repo = "json";
  #       rev = "v${version}";
  #       sha256 = "0y6474xxy027q083vyrz9iyz8xc090nydbd7pbxn58dmgyi0jpgc";
  #     };
  #     patches = [];
  #     cmakeFlags = cmakeFlags ++ ["-DCMAKE_POLICY_VERSION_MINIMUM=3.5"];
  #     doCheck = false;
  #   });

  # openrct2 = let
  #   openrct2-version = "0.4.28";

  #   # Those versions MUST match the pinned versions within the CMakeLists.txt
  #   # file. The REPLAYS repository from the CMakeLists.txt is not necessary.
  #   objects-version = "1.7.3";
  #   openmsx-version = "1.6.1";
  #   opensfx-version = "1.0.6";
  #   title-sequences-version = "0.4.26";

  #   objects = prev.fetchurl {
  #     url = "https://github.com/OpenRCT2/objects/releases/download/v${objects-version}/objects.zip";
  #     hash = "sha256-yBApJkV4cG7R24hmXhKnClg+cdxNPrTbJiU10vBYnqs=";
  #   };
  #   openmsx = prev.fetchurl {
  #     url = "https://github.com/OpenRCT2/OpenMusic/releases/download/v${openmsx-version}/openmusic.zip";
  #     hash = "sha256-mUs1DTsYDuHLlhn+J/frrjoaUjKEDEvUeonzP6id4aE=";
  #   };
  #   opensfx = prev.fetchurl {
  #     url = "https://github.com/OpenRCT2/OpenSoundEffects/releases/download/v${opensfx-version}/opensound.zip";
  #     hash = "sha256-BrkPPhnCFnUt9EHVUbJqnj4bp3Vb3SECUEtzv5k2CL4=";
  #   };
  #   title-sequences = prev.fetchurl {
  #     url = "https://github.com/OpenRCT2/title-sequences/releases/download/v${title-sequences-version}/title-sequences.zip";
  #     hash = "sha256-2ruXh7FXY0L8pN2fZLP4z6BKfmzpwruWEPR7dikFyFg=";
  #   };
  # in
  #   prev.openrct2.overrideAttrs ({buildInputs, ...}: {
  #     pname = "openrct2";
  #     version = openrct2-version;

  #     src = prev.fetchFromGitHub {
  #       owner = "OpenRCT2";
  #       repo = "OpenRCT2";
  #       tag = "v${openrct2-version}";
  #       hash = "sha256-/sgvlfJ3aMqpv5hJNzmnpOq7Bx0BTtGzLOMKGA543O8=";
  #     };

  #     postUnpack = ''
  #       mkdir -p $sourceRoot/data/{object,sequence}
  #       unzip -o ${objects} -d $sourceRoot/data/object
  #       unzip -o ${openmsx} -d $sourceRoot/data
  #       unzip -o ${opensfx} -d $sourceRoot/data
  #       unzip -o ${title-sequences} -d $sourceRoot/data/sequence
  #     '';

  #     buildInputs =
  #       (builtins.filter (x: x.name != "nlohmann_json-3.12.0") buildInputs)
  #       ++ [
  #         nlohmann_json_3_11_3
  #       ];

  #     preConfigure =
  #       # Verify that the correct version of each third party repository is used.
  #       (
  #         let
  #           versionCheck = cmakeKey: version: ''
  #             grep -q '^set(${cmakeKey}_VERSION "${version}")$' CMakeLists.txt \
  #               || (echo "${cmakeKey} differs from expected version!"; exit 1)
  #           '';
  #         in
  #           (versionCheck "OBJECTS" objects-version)
  #           + (versionCheck "OPENMSX" openmsx-version)
  #           + (versionCheck "OPENSFX" opensfx-version)
  #           + (versionCheck "TITLE_SEQUENCE" title-sequences-version)
  #       );

  #     doCheck = false;
  #   });

  _86Box-with-roms = prev.custom._86Box.override {
    unfreeEnableRoms = true;
  };

  # sbcl = prev.sbcl.overrideAttrs (old: {
  #   dontTest = true;
  #   dontCheck = true;
  #   doCheck = false;
  # });

  # sbcl_2_5_7 = prev.sbcl_2_5_7.overrideAttrs (old: {
  #   dontTest = true;
  #   dontCheck = true;
  #   doCheck = false;
  # });

  lcdproc = prev.lcdproc.overrideAttrs (old: {
    # configureFlags = ["--enable-drivers=all"];
    buildInputs = old.buildInputs ++ [prev.custom.glcd-proc-driver prev.custom.graphlcd-base];
  });

  # _389-ds-base = self.packages."${prev.system}"._389-ds-base;
  # freeipa = self.packages."${prev.system}".freeipa;

  # sssd = overridePkgCheckVersionSnapshot "sssd" "2.9.7" (
  #   self.packages."${prev.system}".sssd.override {withSudo = true;}
  # );

  sssd = prev.sssd.overrideAttrs ({
    preConfigure,
    buildInputs,
    ...
  }: {
    preConfigure =
      preConfigure
      + ''
        configureFlagsArray+=("--with-passkey")
        # configureFlagsArray+=("--with-sudo")
      '';
    buildInputs = buildInputs ++ [prev.libfido2];
  });

  #docset = inputs.nixos-dash-docset.packages."${prev.system}".docset;
  # hyprpanel = inputs.hyprpanel.packages."${prev.system}".default;

  tsui = inputs.tsui.packages."${prev.system}".tsui;

  piratebay = inputs.piratebay.packages."${prev.system}".default;

  # wezterm = inputs.wezterm.packages."${prev.system}".default;

  gpio-utils = prev.gpio-utils.overrideAttrs (old: {
    preConfigure = "";
    makeFlags = ["-C tools/gpio"];
  });

  nixd = inputs.nixd.packages."${prev.system}".default;

  # segger-jlink = let
  #   version = "862";
  # in
  #   prev.segger-jlink.overrideAttrs {
  #     src = prev.fetchurl {
  #       url = "https://www.segger.com/downloads/jlink/JLink_Linux_V${version}_x86_64.tgz";
  #       hash = "sha256-3WECMBYbccIlkLdYVNFyXLTKxfxSeNOSWvF0d9ZKdmw=";
  #       curlOpts = "--data accept_license_agreement=accepted";
  #     };
  #     inherit version;
  #   };

  # nrfconnect = let
  #   pname = "nrfconnect";
  #   version = "5.2.0";

  #   src = prev.fetchurl {
  #     url = "https://github.com/NordicSemiconductor/pc-nrfconnect-launcher/releases/download/v${version}/nrfconnect-${version}-x86_64.AppImage";
  #     hash = "sha256-Y42cxK44tFYFj7TFpe+rmSWTo0v5+u9VjG37SCGvmws=";
  #     name = "${pname}-${version}.AppImage";
  #   };

  #   appimageContents = prev.appimageTools.extractType2 {
  #     inherit pname version src;
  #   };
  # in
  #   prev.appimageTools.wrapType2 {
  #     inherit pname version src;

  #     extraPkgs = pkgs: [
  #       prev.segger-jlink-headless
  #     ];

  #     extraInstallCommands = ''
  #       install -Dm444 ${appimageContents}/nrfconnect.desktop -t $out/share/applications
  #       install -Dm444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/nrfconnect.png \
  #         -t $out/share/icons/hicolor/512x512/apps
  #       substituteInPlace $out/share/applications/nrfconnect.desktop \
  #         --replace-fail 'Exec=AppRun' 'Exec=nrfconnect'
  #     '';
  #   };

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

  # handbrake = prev.handbrake.override {};

  # utillinux = prev.util-linux;

  # cockpit-podman = self.packages."${prev.system}".cockpit-podman;
  # cockpit-tailscale = self.packages."${prev.system}".cockpit-tailscale;
  # cockpit-machines = self.packages."${prev.system}".cockpit-machines;
  # cockpit-sensors = self.packages."${prev.system}".cockpit-sensors;
  # cockpit-files = self.packages."${prev.system}".cockpit-files;

  authorized-keys = self.packages."${prev.system}".authorized-keys;

  # ssh-tpm-agent = self.packages."${prev.system}".ssh-tpm-agent;

  intel-vaapi-driver = prev.intel-vaapi-driver.override {enableHybridCodec = true;};

  # tlp = prev.tlp.overrideAttrs (old: {
  #   postInstall =
  #     old.postInstall
  #     + ''
  #       ln -s $out/usr/lib $out/lib
  #       ln -s $out/usr/share $out/share
  #     '';
  # });

  # python312Packages = prev.python312Packages.overrideScope' (pyFinal: pyPrev: {
  #   pymdown-extensions = pyPrev.pymdown-extensions.overrideAttrs (old: {
  #     dontCheck = true;
  #   });
  #   #   mutter = gnomePrev.mutter.overrideAttrs (old: {
  # });

  # pythonPackagesExtensions =
  #   prev.pythonPackagesExtensions
  #   ++ [
  #     (pyfinal: pyprev: {
  #       pymdown-extensions = pyprev.pymdown-extensions.overrideAttrs (old: {
  #         # doCheck = false;
  #         # doInstallCheck = false;
  #         # dontCheck = true;
  #         # checkPhase = '''';
  #         # nativeCheckInputs = [];
  #         installCheckPhase = "";
  #       });
  #     })
  #   ];

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

  # _libqmi = prev.libqmi.overrideAttrs (old: rec {
  #   pname = "libqmi";
  #   version = "1.35.6-dev";

  #   src = prev.fetchFromGitLab {
  #     domain = "gitlab.freedesktop.org";
  #     owner = "mobile-broadband";
  #     repo = "libqmi";
  #     rev = version;
  #     hash = "sha256-kw2i9NVYJTcFbgcuZ8GNS0wt/ZgcomeAP/KWXXAV8Xk=";
  #   };
  # });

  # _libmbim = prev.libmbim.overrideAttrs (old: rec {
  #   pname = "libmbim";
  #   version = "1.31.5-dev";

  #   src = prev.fetchFromGitLab {
  #     domain = "gitlab.freedesktop.org";
  #     owner = "mobile-broadband";
  #     repo = "libmbim";
  #     rev = version;
  #     hash = "sha256-Brut0PobAc6rTbGAo4NTauzHtwJrZOJjEw26hyXqA5w="; # "sha256-sHTpu9WeMZroT+1I18ObEHWSzcyj/Relyz8UNe+WawI=";
  #   };
  # });

  # steam = prev.steam.override {
  #   extraEnv = {
  #     # MANGOHUD = true;
  #     # OBS_VKCAPTURE = true;
  #     # RADV_TEX_ANISO = 16;
  #   };
  #   extraPkgs = pkgs:
  #     with pkgs; [
  #       # mangohud
  #       gamemode
  #     ];
  #   extraLibraries = p:
  #     with p; [
  #       atk
  #       # mangohud
  #     ];
  # };
}
