{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    # services.ttyd = {
    #   enable = true;
    #   interface = "lo";
    # };
    # proxy-services.services = {
    #   "/tty" = {
    #     proxyPass = "http://localhost:${builtins.toString config.services.ttyd.port}";
    #     extraConfig = ''
    #       rewrite /tty(.*) $1 break;
    #     '';
    #   };
    #   "/tty/ws" = {
    #     proxyPass = "http://localhost:${builtins.toString config.services.ttyd.port}/ws";
    #     extraConfig = ''
    #       proxy_http_version 1.1;
    #       proxy_set_header Upgrade $http_upgrade;
    #       proxy_set_header Connection "Upgrade";
    #       proxy_set_header Host $host;
    #     '';
    #   };
    # };
  };
}
