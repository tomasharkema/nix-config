{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [tor];

    services.tor = {
      enable = true;
      client.enable = true;
    };
  };
}
