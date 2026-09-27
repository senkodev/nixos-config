{ config, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases.rebuild = ''sudo nixos-rebuild switch --flake "path:$HOME/nixos-config#${config.networking.hostName}"'';

    ohMyZsh = {
      enable = true;
      theme = "refined";
      plugins = [
        "git"
        "sudo"
        "docker"
        "systemd"
      ];
    };
  };
}
