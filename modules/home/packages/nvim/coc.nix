{
  homeDir,
  pkgs,
  ...
}: {
  eslint.autoFixOnSave = true;
  coc.preferences.colorSupport = false;
  prettier.disableSuccessMessage = true;

  coc.preferences.formatOnSaveFiletypes = [
    "css"
    "javascript"
    "javascriptreact"
    "typescript"
    "typescriptreact"
    "nix"
  ];

  suggest.completionItemKindLabels = {
    variable = "";
    constant = "";
    struct = "פּ";
    class = "ﴯ";
    interface = "";
    text = "";
    enum = "";
    enumMember = "";
    color = "";
    property = "ﰠ";
    field = "ﰠ";
    unit = "塞";
    file = "";
    value = "";
    event = "";
    folder = "";
    keyword = "";
    snippet = "";
    operator = "";
    reference = "";
    typeParameter = "";
    default = "";
  };

  suggest.noselect = false;

  diagnostic = {
    warningSign = "";
    errorSign = "";
    infoSign = "";
  };

  python.jediEnabled = false;

  languageserver = {
    nix = {
      command = "nixd";
      filetypes = ["nix"];
    };
    "csharp-ls" = {
      command = "csharp-ls";
      filetypes = ["cs"];
      rootPatterns = ["*.csproj" ".vim/" ".git/" ".hg/"];
    };
  };

  explorer = {
    icon.enableNerdfont = true;
    width = 30;
    file.showHiddenFiles = true;
    openAction.strategy = "sourceWindow";
    root.customRules = {
      vcs = {patterns = [".git" ".hg" ".projections.json"];};
      vcs-r = {
        patterns = [".git" ".hg" ".projections.json"];
        bottomUp = true;
      };
    };
    root.strategies = ["custom:vcs" "workspace" "cwd"];
    quitOnOpen = true;
    buffer.root.template = "[icon & 1] OPEN EDITORS";
    file.reveal.auto = false;
    file.root.template = "[icon & 1] PROJECT ([root])";
    file.child.template = "[git | 2] [selection | clip | 1] [indent][icon | 1] [diagnosticError & 1][filename omitCenter 1][modified][readonly] [linkIcon & 1][link growRight 1 omitCenter 5]";
    explorer.keyMappings = {
      s = "open:vsplit";
      mm = "rename";
      mc = "copyFile";
      C = "copyFile";
      md = "delete";
      D = "delete";
      ma = "addFile";
      mA = "addDirectory";
    };
  };
}
