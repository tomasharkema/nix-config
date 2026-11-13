{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkgs,
  kernel ? null,
  kernelModuleMakeFlags ? [],
}: let
  kdir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  outputFolder = "${placeholder "out"}/lib/modules/${kernel.modDirVersion}";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "geforce-sriov";
    version = "0.2.2";
    __structuredAttrs = true;
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "noon-at-cgn";
      repo = "geforce-sriov";
      tag = "v${finalAttrs.version}";
      hash = "sha256-JCBElzBbuMfTIE/Bzg1dMdYMhqZOP50vu7jHtT0qUDg=";
    };

    passthru.updateScript = nix-update-script {};

    kernelMod = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-kmod";
      version = finalAttrs.version;
      src = finalAttrs.src;
      makeFlags =
        kernelModuleMakeFlags
        ++ [
          "DESTDIR=$(out)"
          "PREFIX=/"
          "KVER=${kernel.modDirVersion}"
          "KDIR=${kdir}"
          "INSTALL_MOD_PATH=$(out)"
        ];

      nativeBuildInputs = kernel.moduleBuildDependencies;

      sourceRoot = "source/kernel";

      installFlags = [
        "-C"
        "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
        "M=$(PWD)"
      ];

      installTargets = ["modules_install"];
    };

    makeFlags = [
      "DESTDIR=$(out)"
      "PREFIX=$(out)"
    ];

    postInstall = ''
      mkdir -p $out/lib/systemd/system

      cp -rv $out/$out/* $out

      cp -rv ${finalAttrs.kernelMod}/* $out

      mv $out/etc/systemd/system $out/lib/systemd
      rm -rf $out/nix
    '';

    meta = {
      description = "Enable SR-IOV vGPU for consumer Ampere and Ada GeForce cards";
      homepage = "https://github.com/noon-at-cgn/geforce-sriov";
      changelog = "https://github.com/noon-at-cgn/geforce-sriov/blob/${finalAttrs.src.rev}/CHANGELOG.md";
      license = with lib.licenses; [
        mit
        gpl2Only
      ];
      maintainers = with lib.maintainers; [];
      mainProgram = "geforce-sriov";
      platforms = lib.platforms.all;
    };
  })
