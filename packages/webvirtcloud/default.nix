{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
with python3Packages;
  buildPythonApplication {
    pname = "webvirtcloud";
    version = "0.0.1";

    src = fetchFromGitHub {
      owner = "retspen";
      repo = "webvirtcloud";
      rev = "218ec5dd7885cbbe2fbd79365cd44f0a767e3f88";
      hash = "sha256-aR1B+Qv+9+9Tht+/x8VZ3mId8ZZamRYC2X4po0AmEwI=";
    };

    propagatedBuildInputs = [
      django
      drf-nested-routers

      eventlet
      gunicorn
      libsass
      libvirt
      lxml
      ldap3
      markdown
      python-engineio
      python-socketio
      qrcode
      # rwlock
      aiorwlock
      tzdata
      websockify
      whitenoise
      zipp
    ];
  }
# Django==4.2.14
# django_bootstrap5==24.2
# django-bootstrap-icons==0.9.0
# django-login-required-middleware==0.9.0
# django-otp==1.5.0
# django-qr-code==4.1.0
# django-auth-ldap==4.8.0
# djangorestframework==3.15.2
# drf-nested-routers==0.94.1
# drf-yasg==1.21.7
# eventlet==0.36.1
# gunicorn==22.0.0
# libsass==0.23.0
# libvirt-python==10.5.0
# lxml==5.2.2
# ldap3==2.9.1
# markdown==3.6
# #psycopg2-binary
# python-engineio==4.9.1
# python-socketio==5.11.3
# qrcode==7.4.2
# rwlock==0.0.7
# tzdata
# websockify==0.12.0
# whitenoise==6.7.0
# zipp==3.19.2

