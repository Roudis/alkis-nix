# Things specific to this one Mac.
{ ... }:

{
  homebrew = {
    taps = [ "dbt-labs/dbt" ];
    brews = [ "dbt-labs/dbt/dbt" ]; # not packaged in nixpkgs
    casks = [
      "copilot-cli"
      "gcloud-cli"
      "gns3"
      "vlc"
      "wireshark-app"
    ];
  };
}
