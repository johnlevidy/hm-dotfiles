{ pkgs }:
let
  mediaControl = pkgs.runCommand "media-control" { } ''
    cp ${./media_control.sh} "$out"
    chmod +x "$out"
  '';
  bluetooth = pkgs.runCommand "bluetooth" { } ''
    cp ${./bluetooth.sh} "$out"
    chmod +x "$out"
  '';
in
{
  mediaControl = mediaControl;
  bluetooth = bluetooth;
}
