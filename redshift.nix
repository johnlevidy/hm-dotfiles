{ config, pkgs, lib, ... }:
{
  services.redshift = {
    tray = true;
    enable = true;
    temperature = {
      night = 2000;
    };
    latitude = "40.71";
    longitude = "74.00";
    dawnTime = "6:00-7:45";
    duskTime = "18:35-20:15";

    settings.redshift.brightness-day = "1";
    settings.redshift.brightness-night = ".8";
  };
  systemd.user.services.redshift = lib.mkForce {
    Unit = {
      Description = "Redshift colour temperature adjuster";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
    Service = { ExecStart = "${pkgs.redshift}/bin/redshift"; };
  };
}
