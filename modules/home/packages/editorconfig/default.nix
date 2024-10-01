{...}: {
  config = {
    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          indent_style = "space";
          indent_size = "2";
          insert_final_newline = true;
        };
        "*.swift" = {
          indent_style = "space";
          indent_size = "4";
          insert_final_newline = true;
        };
      };
    };
  };
}
