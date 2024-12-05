{
  dockerTools,
  buildEnv,
  pkgs,
  runtimeShell,
}:
with dockerTools;
  buildImage {
    name = "srvadmin-docker";
    tag = "latest";

    fromImage = pullImage {
      imageName = "almalinux";
      imageDigest = "sha256:d7dbaf57916185b2be09e1eaa1156b543f3937164ffa08d7fdc020a0a3800a5a";
      sha256 = "02a98mq1p72rw9y2py4536hmqbrixj0a0r1m9s3885qnmcg59rb4";
      finalImageName = "almalinux";
      finalImageTag = "8";
    };

    # copyToRoot = with dockerTools; [
    #   usrBinEnv
    #   binSh
    #   caCertificates
    #   fakeNss
    # ];

    runAsRoot = ''

      #!${runtimeShell}
      ${dockerTools.shadowSetup}

      yum -y install passwd # gcc wget perl passwd which tar nano dmidecode strace less openssl-devel

      curl -O https://linux.dell.com/repo/hardware/dsu/bootstrap.cgi
      bash bootstrap.cgi
      yum update -y
      yum install -y srvadmin-all dell-system-update

      systemctl enable dsm_om_connsvc.service dsm_sa_snmpd.service dsm_om_shrsvc.service dsm_sa_datamgrd.service dsm_sa_eventmgrd.service
      systemctl disable instsvcdrv.service

    '';
    config = {
      Env = [
        "PATH=$PATH:/opt/dell/srvadmin/bin:/opt/dell/srvadmin/sbin"
        "TOMCATCFG=/opt/dell/srvadmin/lib64/openmanage/apache-tomcat/conf/server.xml"
        "TERM=xterm"
        "USER=root"
        "PASS=password"
        "SYSTEMCTL_SKIP_REDIRECT=1"
        "container=podman"
      ];

      Cmd = [
        "/usr/sbin/init"
      ];
    };

    created = "now";
  }
