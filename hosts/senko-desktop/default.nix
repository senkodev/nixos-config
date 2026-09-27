{ config, pkgs, ... }:
{
  imports = [
    ../../profiles/common
    ../../profiles/desktop

    ./hardware-configuration.nix
    ./stylix.nix
    ./vm.nix
  ];

  networking = {
    networkmanager.enable = true;
    hostName = "senko-desktop";
    nftables.enable = true;

    firewall = {
      enable = true;
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  boot = {
    initrd = {
      luks.devices."luks-ebecfdea-797e-4dd4-9c20-1f7b587c9d1b".device =
        "/dev/disk/by-uuid/ebecfdea-797e-4dd4-9c20-1f7b587c9d1b";

      systemd.network.wait-online.enable = false;
    };

    supportedFilesystems = [ "ntfs" ];
    tmp.useTmpfs = true;
    kernelParams = [ "nohibernate" ];
  };

  time.timeZone = "Asia/Tbilisi";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    printing.enable = true;
    fwupd.enable = true;
  };

  hardware.bluetooth.enable = true;

  systemd = {
    services = {
      tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];

      NetworkManager-wait-online.enable = false;
    };

    network.wait-online.enable = false;
  };

  documentation.nixos.enable = false;

  environment.systemPackages = with pkgs; [
    git
    vim
    vlc
    wget
    fastfetch
    htop
    efibootmgr
  ];

  system.stateVersion = "26.05";
}
