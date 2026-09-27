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

    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ username ];
    };

    ssh.extraConfig = ''
      IdentityAgent ~/.1password/agent.sock
    '';
  };

  environment.etc."1password/custom_allowed_browsers" = {
    text = "helium";
    mode = "0755";
  };
}
