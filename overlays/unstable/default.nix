{channels, self,...}: final: prev: {
  runitor = channels.unstable.runitor;

  vscode = channels.unstable.vscode;
  android-tools = channels.unstable.android-tools;
  freeipa = channels.unstable.freeipa;
  sssd = self.packages."${prev.system}".sssd;
}
