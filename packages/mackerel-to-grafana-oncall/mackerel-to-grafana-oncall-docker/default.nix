{
  dockerTools,
  custom,
  ...
}:
dockerTools.buildImage {
  name = "mackerel-to-grafana-oncall";

  config = {
    Expose = [8000];
    Cmd = ["${custom.mackerel-to-grafana-oncall}/bin/mackerel-to-grafana-oncall"];
  };
}
