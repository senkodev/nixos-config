{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    openssh
    mosh
    rsync
    rclone
    ansible
    opentofu
    nmap
    tcpdump
    wireshark
    dig
    ipcalc
    zmap
    whois
    virt-manager
    jq
    yq
    tmux
    ipmitool
    remmina
    ethtool
    minicom
    gnupg
    yubikey-manager
    yubikey-personalization
  ];

  services = {
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };

  programs = {
    ssh.startAgent = false;
    wireshark.enable = true;
    direnv.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = false; # handled by 1Password
      pinentryPackage = pkgs.pinentry-qt;
    };

    obs-studio = {
      enable = true;

      # optional Nvidia hardware acceleration
      package = pkgs.obs-studio.override {
        cudaSupport = true;
      };

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vaapi # optional AMD hardware acceleration
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };

  virtualisation = {
    libvirtd.enable = true;

    docker = {
      enable = true;
      enableOnBoot = false;
      rootless.enable = true;
    };
  };
}
