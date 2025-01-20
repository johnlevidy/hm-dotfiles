{ pkgs }:
let
  desktopBackground = pkgs.runCommand "background" { } ''
    cp ${./rosette_nebula.jpg} "$out"
  '';
  lockBackground = pkgs.runCommand "lock-background" { } ''
    cp ${./small_rosette_nebula.jpg} "$out"
  '';
in
{
  desktopBackground = desktopBackground;
  lockBackground = lockBackground;
}
