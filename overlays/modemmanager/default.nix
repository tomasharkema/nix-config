{
  channels,
  disko,
  self,
  inputs,
  ...
}: final: prev: {
  libqmi = prev.libqmi.overrideAttrs (old: rec {
    pname = "libqmi";
    version = "1.36.0";

    src = prev.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "mobile-broadband";
      repo = "libqmi";
      rev = version;
      hash = "sha256-cGNnw0vO/Hr9o/eIf6lLTsoGiEkTvZiArgO7tAc208U=";
    };
  });

  libmbim = prev.libmbim.overrideAttrs (old: rec {
    pname = "libmbim";
    version = "1.32.0";

    src = prev.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "mobile-broadband";
      repo = "libmbim";
      rev = version;
      hash = "sha256-+4INXuH2kbKs9C6t4bOJye7yyfYH/BLukmgDVvXo+u0="; # "sha256-sHTpu9WeMZroT+1I18ObEHWSzcyj/Relyz8UNe+WawI=";
    };
  });
  #_modemmanager = prev.custom.modemmanager-xmm;

  modemmanager = prev.modemmanager.overrideAttrs (
    old: rec {
      pname = "modemmanager";
      version = "1.24.2";

      src = prev.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "mobile-broadband";
        repo = "ModemManager";
        rev = version;
        hash = "sha256-rBLOqpx7Y2BB6/xvhIw+rDEXsLtePhHLBvfpSuJzQik=";
      };
      #     patches = [];
      #     mesonFlags =
      #       old.mesonFlags
      #       + [
      #         "--sysconfdir=${placeholder "out"}/etc"
      #       ];
    }
  );

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
}
