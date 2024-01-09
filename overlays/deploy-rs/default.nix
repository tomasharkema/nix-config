{deploy-rs, ...}: final: prev: {
  deploy-rs = deploy-rs.packages.${prev.system}.default;
}
