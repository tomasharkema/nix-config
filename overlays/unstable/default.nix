{channels, ...}: final: prev: {
  runitor = channels.unstable.runitor;

  vscode = channels.unstable.vscode;
  android-studio = channels.unstable.android-studio;
  android-tools = channels.unstable.android-tools;
}
