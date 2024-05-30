{channels, ...}: final: prev: let
  # pkgs = channels.unstable;
in {
  ipmicfg = prev.ipmicfg.overrideAttrs {
    src = prev.fetchzip {
      url = "https://www.supermicro.com/wdl/utility/IPMICFG/IPMICFG_1.35.1_build.230912.zip";
      hash = "sha256-C8dXulXOTmfemnFhYNKXue0iCMxFc4ScxjlAD2RX350=";
    };
  };
}
