{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      add_newline = false;
      # Purple -> Red -> Yellow -> Blue(nix) -> end; no language/tool modules
      format = "$status$cmd_duration\n(bg:#cc241d fg:#b16286)$directory[](fg:#cc241d bg:#458588)$nix_shell[](fg:#458588 bg:#d79921)$git_branch$git_status[ ](fg:#d79921)";

      # TODO: once i have 1.22 starship this can be cleaned up with succ / fail format
      status = {
        disabled = false;
        map_symbol = true;
        pipestatus = true;
        format = "$symbol";
        symbol         = "[✖ $status](fg:#fb4934)";  # failure -> red + code
        success_symbol = "[✔](fg:#b8bb26)";          # success -> green, no code
      };


      cmd_duration = {
        min_time = 500;
        show_notifications = true;
        show_milliseconds = true;
        format = "[(\\($duration\\))]($style)";  # renders like (123ms)
      };

      directory = {
        style = "bg:#cc241d fg:#fbf1c7";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "bg:#d79921 fg:#282828";  # dark fg on yellow
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style  = "bg:#d79921 fg:#282828";
        format = "[($staged$modified$untracked$ahead_behind)]($style)";
        staged   = "+$count";
        modified = "~$count";
        untracked = "?$count";
        ahead    = "⇡$count";
        behind   = "⇣$count";
      };

      # Nix shell status (blue bg); tight symbol-name spacing
      nix_shell = {
        style = "bg:#458588 fg:#fbf1c7";
        heuristic = true;
        symbol = "❄";
        impure_msg = "";
        format = "[ $symbol $name ]($style)";  # the gap is U+202F
      };
    };
  };
}
