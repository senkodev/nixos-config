{
  pkgs,
  username,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases.rebuild = ''sudo nixos-rebuild switch --flake "path:$HOME/nixos-config#senko-desktop"'';

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
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "kvm"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      telegram-desktop
      mattermost-desktop
      claude-code
      helium
      spotify
      vesktop
      thunderbird
      unityhub
      blender
      trayscale
    ];
  };
}
