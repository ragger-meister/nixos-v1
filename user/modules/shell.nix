{ config, pkgs, theme, ... }:

{
  programs.bash = {
    enable = true;
    historyControl = [ "erasedups" "ignorespace" ];
    historySize = 10000;
    historyFileSize = 20000;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$username$hostname$directory$git_branch$git_status$character";
      username = {
        show_always = false;
        style_user = "white";
        style_root = "red";
        format = "[$user]($style) ";
      };
      hostname = {
        ssh_only = true;
        style = "yellow";
        format = "[@$hostname]($style) ";
      };
      directory = {
        style = "blue";
        truncation_length = 3;
        truncation_symbol = "../";
        read_only = " *";
      };
      git_branch = {
        style = "purple";
        format = "[$branch]($style) ";
      };
      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "red";
      };
      character = {
        success_symbol = "[>](white)";
        error_symbol = "[>](red)";
      };
      sudo = {
        disabled = false;
        symbol = "* ";
        style = "red";
        format = "[$symbol]($style)";
      };
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 10000;
  };
}
