{
  dockerTools,
  custom,
  ...
}:
dockerTools.buildImage {
  name = "mackerel-to-grafana-oncall";
  tag = "latest";
  config = {
    Expose = [8000];
    Entrypoint = ["${custom.mackerel-to-grafana-oncall}/bin/mackerel-to-grafana-oncall"];
  };
}
