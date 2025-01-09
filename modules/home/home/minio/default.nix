{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      minio-client
    ];

    home.file = {
      ".mc/config.json".text = builtins.toJSON {
        version = 10;
        aliases = {
          nix = {
            url = "http://dione.mastodon-mizar.ts.net:9100";
            accessKey = "admin";
            secretKey = "<adminsecret>";
            api = "S3v4";
            lookup = "auto";
          };
        };
      };
    };
  };
}
