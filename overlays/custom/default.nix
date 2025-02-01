{
  channels,
  disko,
  self,
  inputs,
  ...
}: final: prev: let
  overridePkgCheckVersionSnapshot = name: version: pkg: (
    let
      pkgVersion = prev."${name}".version;
    in
      if (pkgVersion == version)
      then pkg
      else (builtins.throw "nixpkgs' upstream for ${name} has been updated to ${pkgVersion}. (yours is at ${pkg.version} with snapshot ${version})")
  );
in rec {
  libcec = prev.libcec.override {withLibraspberrypi = true;};

  # nix-htop = inputs.nix-htop.packages."${prev.system}".nix-htop;

  # _389-ds-base = self.packages."${prev.system}"._389-ds-base;
  freeipa =
    #builtins.trace "${prev.freeipa.version} ${final.freeipa.version}"
    self.packages."${prev.system}".freeipa;

  sssd = overridePkgCheckVersionSnapshot "sssd" "2.9.5" (
    self.packages."${prev.system}".sssd.override {withSudo = true;}
  );

  docset = inputs.nixos-dash-docset.packages."${prev.system}".docset;

  tsui = inputs.tsui.packages."${prev.system}".tsui;

  piratebay = inputs.piratebay.packages."${prev.system}".default;

  # wezterm = inputs.wezterm.packages."${prev.system}".default;

  # nixd = inputs.nixd.packages."${prev.system}".default;

  udisks = overridePkgCheckVersionSnapshot "udisks2" "" udisks2;

  udisks2 = prev.udisks2.overrideAttrs (old: {
    buildInputs =
      old.buildInputs
      ++ [
        prev.libiscsi
        prev.libconfig
      ];
    # doCheck = false;
    configureFlags =
      old.configureFlags
      ++ [
        "--enable-all-modules"
        "--enable-btrfs"
        "--enable-lvm2"
        "--enable-smart"
        # "--enable-lsm"
        # "--enable-iscsi"
      ];
  });

  # utillinux = prev.util-linux;

  # dosbox-x = prev.dosbox-x.overrideAttrs ({postInstall ? "", ...}: {
  #   postInstall =
  #     postInstall
  #     + prev.lib.optionalString prev.hostPlatform.isDarwin ''
  #       cp -v ${prev.custom.openglide}/lib/* $out/Applications/dosbox-x.app/Contents/Resources/
  #     '';
  #   # https://www.vogons.org/download/file.php?id=102360
  # });
  # ffmpeg = prev.ffmpeg.override {ffmpegVariant = "full";};

  #cockpit = overridePkgCheckVersionSnapshot "cockpit" "331" (self.packages."${prev.system}".cockpit.override {withOldBridge = true;});
  #cockpit = prev.cockpit.overrideAttrs (old: {

  #fixupPhase = old.fixupPhase + ''
  #'';

  #postFixup = ''
  #    for file in $out/share/cockpit/*/manifest.json; do
  #      substituteInPlace $file \
  #      --replace-warn /usr /run/current-system/sw
  #    done
  # '';

  #});
  cockpit-podman = self.packages."${prev.system}".cockpit-podman;
  cockpit-tailscale = self.packages."${prev.system}".cockpit-tailscale;
  cockpit-machines = self.packages."${prev.system}".cockpit-machines;
  cockpit-sensors = self.packages."${prev.system}".cockpit-sensors;
  cockpit-files = self.packages."${prev.system}".cockpit-files;

  authorized-keys = self.packages."${prev.system}".authorized-keys;

  ssh-tpm-agent = self.packages."${prev.system}".ssh-tpm-agent;

  intel-vaapi-driver = prev.intel-vaapi-driver.override {enableHybridCodec = true;};

  zjstatus = inputs.zjstatus.packages.${prev.system}.default;

  # mission-center = prev.mission-center.overrideAttrs ({postPatch, ...}: {
  #   postPatch =
  #     prev.lib.replaceStrings [
  #       "substituteInPlace $cargoDepsCopy/gl_loader-*/src/glad.c"
  #       "--replace-fail \"libGL.so.1"
  #     ] [
  #       "# substituteInPlace $cargoDepsCopy/gl_loader-*/src/glad.c"
  #       "# --replace-fail \"libGL.so.1"
  #     ]
  #     postPatch;
  # });

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

  # modemmanager = prev.modemmanager.overrideAttrs (oldAttrs: {
  # src = prev.fetchFromGitLab {
  #   # https://gitlab.freedesktop.org/tuxor1337/ModemManager/-/tree/port-xmm7360
  #   domain = "gitlab.freedesktop.org";
  #   owner = "tuxor1337";
  #   repo = "ModemManager";
  #   rev = "port-xmm7360";
  #   sha256 = "sha256-eUamC9Bi9HpukWXVLol6O3QoNFa5mIMNOake2IDSEFU=";
  # };
  # patches =
  #   oldAttrs.patches
  #   ++ [
  #     (prev.fetchpatch {
  #       url = "https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/1200.patch";
  #       hash = "sha256-7z3YMNbrU1E55FgmOaTFbsK2qXCBnbRkDrS+Yogxgow=";
  #     })
  #   ];
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
