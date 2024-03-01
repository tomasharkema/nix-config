{
  pkgs,
  config,
  ...
}: {
  config = {
    # nix-store --generate-binary-cache-key tomas-peerix /home/tomas/tomas-peerix-secret.key /home/tomas/tomas-peerix-public.key
    services.peerix = {
      enable = true;
      user = "tomas";
      group = "tomas";
      publicKeyFile = "/home/tomas/tomas-peerix-public.key";
      privateKeyFile = "/home/tomas/tomas-peerix-secret.key";
    };
  };
}
