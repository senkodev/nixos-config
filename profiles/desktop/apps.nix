{
  pkgs,
  username,
  ...
}:
{
  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    gamemode.enable = true;

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ username ];
    };

    ssh.extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };
  # fixes games crashing when running through proton
  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

  environment.etc."1password/custom_allowed_browsers" = {
    text = "helium";
    mode = "0755";
  };
}
