{ pkgs }:
let
  background = pkgs.runCommand "background" { } ''
    cp ${./rosette_nebula.jpg} "$out"
    chmod +x "$out"
  '';
in
{
  background = background;
}
