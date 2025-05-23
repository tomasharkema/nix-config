{
  stdenv,
  lib,
  pkgs,
  fetchFromGitHub,
  fetchurl,
  pkg-config,
  autoconf,
  automake,
  krb5,
  openldap,
  popt,
  cyrus_sasl,
  curl,
  xmlrpc_c,
  autoreconfHook,
  ding-libs,
  p11-kit,
  gettext,
  nspr,
  nss,
  _389-ds-base,
  svrcore,
  libuuid,
  talloc,
  tevent,
  samba,
  libunistring,
  libverto,
  libpwquality,
  systemd,
  bind,
  sssd,
  jre,
  rhino,
  lesscpy,
  jansson,
  runtimeShell,
  git,
}: let
  pathsPy = ./paths.py;

  python3 = pkgs.python3.withPackages (
    ps:
      with ps; [
        setuptools
        distlib
        distutils-extra
      ]
  );

  cryptographyNew = python3.pkgs.cryptography.overridePythonAttrs (old: rec {
    pname = "cryptography";
    version = "43.0.1"; # Also update the hash in vectors.nix

    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-ID6Sp1cW2M+0kdxHx54X0NkgfM/8vLNfWY++RjrjRE0=";
    };
    cargoRoot = "src/rust";
    doCheck = false;
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit src;
      sourceRoot = "${pname}-${version}/${cargoRoot}";
      name = "${pname}-${version}";
      hash = "sha256-QZ6gUVhm9DZVIMNL0xb2SY59N99q4NSWEs1K76HNZ7g=";
    };
  });

  pythonInputs = with python3.pkgs; [
    six
    python-ldap
    dnspython
    netaddr
    netifaces
    gssapi
    dogtag-pki
    pyasn1
    sssd
    cffi
    lxml
    dbus-python
    cryptographyNew
    python-memcached
    qrcode
    pyusb
    yubico
    setuptools
    jinja2
    augeas
    samba
  ];
in
  stdenv.mkDerivation rec {
    pname = "freeipa";
    version = "4.12.3";

    src = fetchFromGitHub {
      owner = "freeipa";
      repo = "freeipa";
      rev = "release-${builtins.replaceStrings ["."] ["-"] version}";
      hash = "sha256-TFYzddiQlp0tB6CKC9yxii6kmbRyYiwPYqYNad2dp0M=";
    };

    nativeBuildInputs = [
      autoreconfHook
      python3
      python3.pkgs.wrapPython
      #python3.pkgs.setuptools
      #python3.pkgs.distlib
      #python3.pkgs.distutils-extra
      jre
      rhino
      lesscpy
      automake
      autoconf
      gettext
      pkg-config
      git
    ];

    buildInputs =
      [
        krb5
        openldap
        openldap.dev
        popt
        cyrus_sasl
        curl
        xmlrpc_c
        ding-libs
        p11-kit
        python3
        nspr
        nss
        _389-ds-base
        svrcore
        libuuid
        talloc
        tevent
        samba
        libunistring
        libverto
        systemd
        bind
        libpwquality
        jansson
      ]
      ++ pythonInputs;

    postPatch = ''
      patchShebangs makeapi makeaci install/ui/util

      substituteInPlace ipaplatform/setup.py \
        --replace 'ipaplatform.debian' 'ipaplatform.nixos'

      substituteInPlace ipasetup.py.in \
        --replace 'int(v)' 'int(v.replace("post", ""))'

      substituteInPlace client/ipa-join.c \
        --replace /usr/sbin/ipa-getkeytab $out/bin/ipa-getkeytab

      cp -r ipaplatform/{fedora,nixos}
      substitute ${pathsPy} ipaplatform/nixos/paths.py \
        --subst-var out \
        --subst-var-by bind ${bind.dnsutils} \
        --subst-var-by curl ${curl} \
        --subst-var-by krb5 ${krb5} \
        --subst-var-by sssd ${sssd}
    '';

    NIX_CFLAGS_COMPILE = "-I${_389-ds-base}/include/dirsrv";
    pythonPath = pythonInputs;

    # Building and installing the server fails with silent Rhino errors, skipping
    # for now. Need a newer Rhino version.
    # buildFlags = [
    #   "client"
    #   "server"
    # ];

    configureFlags = [
      "--with-systemdsystemunitdir=$out/lib/systemd/system"
      "--with-ipaplatform=nixos"
      "--disable-server"

      # "--enable-server"
      # "--with-ldap"
      # "LDAP_DIR=${openldap.dev}"
      # "LDAPIDIR=${openldap.dev}"
      # "LDAP_INCDIR=${openldap.dev}/include"
      # "LDAP_LIBDIR=${openldap.out}/lib"
      # "LDAP_LIBS=${openldap.out}/lib"
      # "LDAP_CFLAGS=-I${openldap.dev}/include"
    ];

    # LDAP_DIR = "${openldap.dev}";
    # LDAPIDIR = "${openldap.dev}";
    # LDAP_INCDIR = "${openldap.dev}/include";
    # LDAP_LIBDIR = "${openldap.out}/lib";
    # LDAP_LIBS = "${openldap.out}/lib";
    # LDAP_CFLAGS = "-I${openldap.dev}/include";

    # postInstall = ''
    #   echo "
    #    #!${runtimeShell}
    #    echo 'ipa-client-install is not available on NixOS. Please see security.ipa, instead.'
    #    exit 1
    #   " > $out/sbin/ipa-client-install
    # '';

    postFixup = ''
      wrapPythonPrograms
      rm -rf $out/etc/ipa $out/var/lib/ipa-client/sysrestore
    '';

    meta = {
      description = "Identity, Policy and Audit system";
      longDescription = ''
        IPA is an integrated solution to provide centrally managed Identity (users,
        hosts, services), Authentication (SSO, 2FA), and Authorization
        (host access control, SELinux user roles, services). The solution provides
        features for further integration with Linux based clients (SUDO, automount)
        and integration with Active Directory based infrastructures (Trusts).
      '';
      homepage = "https://www.freeipa.org/";
      license = lib.licenses.gpl3Plus;
      maintainers = [lib.maintainers.s1341];
      platforms = lib.platforms.linux;
      mainProgram = "ipa";
    };
  }
