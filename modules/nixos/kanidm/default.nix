{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    services.kanidm = {
      enableClient = true;
      enablePam = true;
      clientSettings = {
        uri = "https://idm.harke.ma";
      };
      unixSettings.pam_allowed_login_groups = ["allusers"];
    };
  };
}
