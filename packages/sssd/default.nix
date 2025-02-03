{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  makeWrapper,
  python3Packages,
  glibc,
  adcli,
  augeas,
  dnsutils,
  c-ares,
  curl,
  cyrus_sasl,
  ding-libs,
  libnl,
  libunistring,
  nss,
  samba,
  nfs-utils,
  doxygen,
  python311,
  pam,
  popt,
  talloc,
  tdb,
  tevent,
  pkg-config,
  ldb,
  openldap,
  pcre2,
  libkrb5,
  cifs-utils,
  glib,
  keyutils,
  dbus,
  fakeroot,
  libxslt,
  libxml2,
  libuuid,
  systemd,
  nspr,
  check,
  cmocka,
  uid_wrapper,
  p11-kit,
  nss_wrapper,
  ncurses,
  libfido2,
  po4a,
  http-parser,
  jansson,
  jose,
  docbook_xsl,
  docbook_xml_dtd_45,
  testers,
  nix-update-script,
  nixosTests,
  withSudo ? false,
  fetchpatch,
  gdm,
  ensureNewerSourcesForZipFilesHook,
  libcap,
  openssh,
  softhsm,
  gnutls,
}: let
  docbookFiles = "${docbook_xsl}/share/xml/docbook-xsl/catalog.xml:${docbook_xml_dtd_45}/xml/dtd/docbook/catalog.xml";
  py = python311.pythonOnBuildForHost.withPackages (ps:
    with ps; [
      setuptools
      python-ldap
      # distutils-extra
      # distlib
    ]);
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "sssd";
    # version 2.10.2 breaks PAM
    version = "2.10.1";

    src = fetchFromGitHub {
      owner = "SSSD";
      repo = "sssd";
      rev = "refs/tags/${finalAttrs.version}";
      sha256 = "sha256-p/PijS84fCorm2UyiFYZl+Li8+rUUQiPIImRN7xJmRk=";
    };

    # patches = [
    #   # Fix the build with Samba 4.20
    #   (fetchpatch {
    #     url =
    #       "https://github.com/SSSD/sssd/commit/1bf51929a48b84d62ac54f2a42f17e7fbffe1612.patch";
    #     hash = "sha256-VLx04APEipp860iOJNIwTGywxZ7rIDdyh3te6m7Ymlo=";
    #   })
    # ];

    postPatch = ''
      patchShebangs ./sbus_generate.sh.in
    '';

    # Something is looking for <libxml/foo.h> instead of <libxml2/libxml/foo.h>
    env.NIX_CFLAGS_COMPILE = toString [
      ''-DRENEWAL_PROG_PATH="${adcli}/bin/adcli"''
      "-I${libxml2.dev}/include/libxml2"
    ];

    preConfigure =
      ''
        export SGML_CATALOG_FILES="${docbookFiles}"

        export PYTHONPATH=$(find ${py} -type d -name site-packages)
        export PATH=$PATH:${openldap}/libexec:${openssh}/bin:${softhsm}/bin:${gnutls}/bin

        configureFlagsArray=(
          --prefix=$out
          --sysconfdir=/etc
          --localstatedir=/var
          --datadir=$out/share
          --libexecdir=$out/libexec
          --enable-pammoddir=$out/lib/security
          --enable-nsslibdir=$out/lib
          --libdir=$out/lib
          --with-os=fedora
          --with-pid-path=/run
          --with-python3-bindings
          --with-syslog=journald
          --without-selinux
          --without-semanage
          --with-passkey
          --with-initscript=systemd
          --with-sssd-user=root
          --with-xml-catalog-path=''${SGML_CATALOG_FILES%%:*}
          --with-ldb-lib-dir=$out/modules/ldb
          --with-nscd=${glibc.bin}/sbin/nscd
        )
      ''
      + lib.optionalString withSudo ''
        configureFlagsArray+=("--with-sudo")
      '';

    enableParallelBuilding = true;
    # Disable parallel install due to missing depends:
    #   libtool:   error: error: relink '_py3sss.la' with the above command before installing i
    enableParallelInstalling = false;

    nativeBuildInputs = [
      ensureNewerSourcesForZipFilesHook
      py
      python3Packages.wrapPython
      autoreconfHook
      makeWrapper
      pkg-config
      doxygen
      # python3Packages.setuptools
    ];

    propagatedBuildInputs = with python3Packages; [
      py
      #   # distutils-extra
      #   # distlib
      setuptools
    ];

    # sssd> checking for ssh-keygen... no
    # sssd> configure: Could not find ssh-keygen
    # sssd> configure: Could not find softhsm2 PKCS11 module
    # sssd> checking for softhsm2-util... no
    # sssd> configure: Could not find softhsm2-util
    # sssd> checking for p11tool... no
    # sssd> configure: Could not find p11tool

    buildInputs = [
      gnutls
      openssh
      softhsm
      libcap
      py
      gdm
      augeas
      dnsutils
      c-ares
      curl
      cyrus_sasl
      ding-libs
      libnl
      libunistring
      nss
      samba
      nfs-utils
      p11-kit
      # python3
      popt
      talloc
      tdb
      tevent
      ldb
      pam
      openldap
      pcre2
      libkrb5
      cifs-utils
      glib
      keyutils
      dbus
      fakeroot
      libxslt
      libxml2
      libuuid
      systemd
      nspr
      check
      cmocka
      uid_wrapper
      nss_wrapper
      ncurses
      libfido2
      po4a
      http-parser
      jansson
      jose
      # python311.pkgs.python-ldap
    ];

    makeFlags = [
      "SGML_CATALOG_FILES=${docbookFiles}"
    ];

    installFlags = [
      "sysconfdir=$(out)/etc"
      "localstatedir=$(out)/var"
      "pidpath=$(out)/run"
      "sss_statedir=$(out)/var/lib/sss"
      "logpath=$(out)/var/log/sssd"
      "pubconfpath=$(out)/var/lib/sss/pubconf"
      "dbpath=$(out)/var/lib/sss/db"
      "mcpath=$(out)/var/lib/sss/mc"
      "pipepath=$(out)/var/lib/sss/pipes"
      "gpocachepath=$(out)/var/lib/sss/gpo_cache"
      "secdbpath=$(out)/var/lib/sss/secrets"
      "initdir=$(out)/rc.d/init"
      "libexecdir=$(out)/libexec"
      "ldblibdir=$(out)/modules/ldb"
    ];

    postInstall = ''
      rm -rf "$out"/run
      rm -rf "$out"/rc.d
      rm -f "$out"/modules/ldb/memberof.la
      find "$out" -depth -type d -exec rmdir --ignore-fail-on-non-empty {} \;
    '';
    postFixup = ''
      for f in $out/bin/sss{ctl,_cache,_debuglevel,_override,_seed} $(find $out/libexec/ -type f -executable); do
        wrapProgram $f --prefix LDB_MODULES_PATH : $out/modules/ldb
      done

      # wrapProgram $out/bin/sssd --prefix LDB_MODULES_PATH : $out/modules/ldb
      # wrapProgram "$out/libexec/sssd/sssd_pam" --prefix LDB_MODULES_PATH : $out/modules/ldb

      wrapPythonProgramsIn "$out/libexec/sssd/sss_analyze" "${py}"
    '';

    doCheck = true;
    checkPhase = ''
      file $out/lib/sssd/modules/sssd_krb5_passkey_plugin.so
      file $out/libexec/sssd/sssd_kcm
      file $out/lib/p11-kit-proxy.so
    '';

    passthru = {
      tests = {
        inherit (nixosTests) sssd sssd-ldap;
        version = testers.testVersion {
          package = finalAttrs.finalPackage;
          command = "sssd --version";
        };
      };
      updateScript = nix-update-script {};
    };

    meta = {
      description = "System Security Services Daemon";
      homepage = "https://sssd.io/";
      changelog = "https://sssd.io/release-notes/sssd-${finalAttrs.version}.html";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [illustris];
      pkgConfigModules = [
        "ipa_hbac"
        "sss_certmap"
        "sss_idmap"
        "sss_nss_idmap"
      ];
    };
  })
