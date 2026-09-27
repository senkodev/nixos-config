{
  pkgs,
  username,
  ...
}:
{
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
      prismlauncher
      r2modman
      termius
    ];
  };
}
