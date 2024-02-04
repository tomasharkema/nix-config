{pkgs, ...}: {
  config = {
    # gh = "op plugin run -- gh";
    programs = {
      gh = {
        enable = true;
        extensions = with pkgs; [
          gh-dash
          # gh-token
        ];
      };

      gh-dash = {enable = true;};
    };
  };
}
