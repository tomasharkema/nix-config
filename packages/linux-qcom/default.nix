{
  lib,
  fetchFromGitHub,
  buildLinux,
  linuxPackagesFor,
  ccacheStdenv,
  fetchpatch,
  ...
}: let
  gammaPatch = {
    name = "gamma";
    patch = fetchpatch {
      url = "https://patchwork.kernel.org/project/linux-arm-msm/patch/20251018-dpu-add-dspp-gc-driver-v1-1-ed0369214252@izzo.pro/mbox/";
      sha256 = "sha256-ez9nsrfhKGiP/YB9LsyRISYPDK1l9G8aqjnacCltQDE=";
    };
  };
in
  # linuxPackagesFor ( (buildLinux {
  #   version = "6.19";
  #   src = fetchFromGitHub {
  #     owner = "jglathe";
  #     repo = "linux_ms_dev_kit";
  #     rev = "jg/ubuntu-qcom-x1e-6.19.0-jg-0";
  #     hash = "sha256-PLQaIKZ6Kcwf56CgxNQg45EilTOi6xnjgPjP6BsTcgM=";
  #   };
  # })
  # linuxPackagesFor ((buildLinux {
  #   version = "6.19";
  #   src = fetchFromGitHub {
  #     owner = "jglathe";
  #     repo = "linux_ms_dev_kit";
  #     rev = "jg/ubuntu-qcom-x1e-6.19.y";
  #     hash = "sha256-CTbrI+lX6LrhB7lJ3av7e48jGpD4OLd7gIE1+4pCzco=";
  #  };
  (buildLinux {
    version = "6.19";
    src = fetchFromGitHub {
      owner = "jglathe";
      repo = "linux_ms_dev_kit";
      rev = "jg/sp12_dt";
      hash = "sha256-dcS5AHP40Saz21ZilNFYX4WtgYf404z+setpywvsopw=";
    };

    kernelPatches = [
      gammaPatch
    ];
  })
   .override {stdenv = ccacheStdenv;}
