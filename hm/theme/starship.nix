{ ... }:

{
  # Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;

      format = "$username$hostname$directory$git_branch$git_status$nix_shell$cmd_duration$line_break$character";
      right_format = "$time";

      username = {
        show_always = true;
        style_user = "bold green";
        format = "[$user]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "bold white";
        format = "[@$hostname ]($style)";
      };

      directory = {
        style = "bold cyan";
        truncation_length = 4;
        truncate_to_repo = false;
        format = "[$path]($style) ";
      };

      git_branch = {
        symbol = "git:";
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        style = "bold red";
        format = "[$all_status$ahead_behind]($style) ";
      };

      nix_shell = {
        symbol = "nix ";
        style = "bold blue";
        format = "[$symbol$state( \\($name\\))]($style) ";
      };

      cmd_duration = {
        min_time = 1000;
        style = "bold white";
        format = "took [$duration]($style) ";
      };

      time = {
        disabled = false;
        time_format = "%H:%M";
        style = "bold white";
        format = "[$time]($style)";
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
        vimcmd_symbol = "[<](bold green)";
      };
    };
  };
}
