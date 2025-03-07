{
  lib,
  config,
  ...
}: let
  cfg = config.services."nix-private-cache";
in {
  options.services."nix-private-cache" = {
    enable = lib.mkEnableOption "nix-private-cache";
  };

  config = lib.mkIf cfg.enable {
    #   # Caching reverse proxy for Nix substituters.

    # # This file defines Nginx configuration that makes Nginx forward requests to the
    # # Nix substituters that we use, and then cache the responses on disk. Subsequent
    # # requests for the same URLs will then be served from disk instead of having to
    # # go over the network, which should be much faster.

    # # === COMMON OPTIONS FOR ALL UPSTREAMS ===
    # # First off, some common configuration options for all vhosts in this file.
    # # Note that because these options are in the `http` context these options will
    # # also apply to any other `proxy_pass` directives for this server!
    # # If you apply this to an existing Nginx server you'll want to move these
    # # directives into the `server` blocks.

    # # Tell Nginx to set up a response cache at `/data/nginx/cache`, with a maximum
    # # size of 800 GB or 400_000 stored files.
    # # Also set `inactive` to tell Nginx to keep files until they haven't been
    # # accessed for a year, instead of the default of removing files after they
    # # haven't been accessed for 10 minutes.
    # # See: https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_path
    # proxy_cache_path /data/nginx/cache max_size=800G keys_zone=cache_zone:50m inactive=365d;

    # # Tell Nginx to actually use the response cache to cache requests.
    # # See: https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache
    # proxy_cache cache_zone;

    # # Since Nix store paths are immutable, we can cache successful responses for a
    # # long time.
    # # We only want to cache successful responses: if we get a 404 error or a 401
    # # error, we want the request to be retried the next time a client asks for it.
    # # This is the default behaviour of `proxy_cache_valid` if no specific response
    # # codes are specified.
    # # See: https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_valid
    # proxy_cache_valid 200 365d;
    # proxy_cache_use_stale error timeout invalid_header updating http_500 http_502 http_504 http_403 http_404 http_429;

    # # Important: We need to ignore all common Cache-Control headers, since nginx by default
    # # gives them HIGHER priority than the proxy_cache_valid directive above. We do not
    # # want that, since we know that Nix urls are immutable.
    # # See: https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ignore_headers
    # proxy_ignore_headers X-Accel-Expires Expires Cache-Control Set-Cookie;

    # # Enable request deduplication for requests to the upstream servers.
    # # This means that if two requests come in for the same store path the second
    # # request will wait for the first request to complete (hopefully successfully)
    # # and then serve that response, instead of opening two connections to the
    # # upstream server.
    # # See: https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_lock
    # proxy_cache_lock on;

    # # Disable IPv6 resolution: our office network does not offer IPv6 addresses, but
    # # Nginx will still attempt to connect to IPv6 addresses, which spams the error
    # # log.
    # # You'll probably want to remove this option if your network does support IPv6
    # # or you use a different DNS server.
    # # See: https://nginx.org/en/docs/http/ngx_http_core_module.html#resolver
    # resolver 8.8.8.8 ipv6=off;

    # # When connecting to an upstream server, do use TLS SNI to indicate which server
    # # to connect to. Without this option Nginx fails to connect to Cachix upstreams.
    # # See: https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_server_name
    # proxy_ssl_server_name on;

    # # When connecting to an upstream server, do verify the TLS certificate since
    # # this is outside of our network. Nginx defaults to not verifying certificates.
    # # See: https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_ssl_trusted_certificate
    # proxy_ssl_verify on;
    # proxy_ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;

    # # === PER-UPSTREAM CONFIGURATION ===
    # # With the above common configuration options, we can now define the upstream
    # # substituters to connect to.

    # # For each upstream substituter we define a separate `server` block that
    # # forwards traffic to the actual server. Nginx will determine based on the Host
    # # header which upstream server is to be used, and will check if the requested
    # # data is present in the cache before forwarding the request to the upstream
    # # substituter.

    services.nginx.virtualHosts = {
      "cache-nixos-org.cachixcache" = {
        serverName = "cache-nixos-org.cachixcache";

        locations = {
          "/" = {
            extraConfig = ''
              proxy_set_header Host $proxy_host;
            '';
            proxyPass = "https://cache.nixos.org";
          };
        };
      };
      "tomasharkema-cachix-org.cachixcache" = {
        serverName = "tomasharkema-cachix-org.cachixcache";

        locations = {
          "/" = {
            extraConfig = ''
              proxy_set_header Host $proxy_host;
            '';
            proxyPass = "https://tomasharkema.cachix.org";
          };
        };
      };
    };
  };
}
