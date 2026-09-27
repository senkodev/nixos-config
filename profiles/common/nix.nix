_: {
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: _prev: {
      helium = final.callPackage ../../pkgs/helium.nix { };
      apple-color-emoji = final.callPackage ../../pkgs/apple-color-emoji.nix { };
    })
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  programs.nix-ld.enable = true;
}
