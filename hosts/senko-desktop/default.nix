{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/apps.nix
    ../../modules/boot.nix
    ../../modules/graphics.nix
    ../../modules/home.nix
    ../../modules/ops.nix
    ../../modules/plasma.nix
    ../../modules/settings.nix
    ../../modules/stylix.nix
    ../../modules/telemetry.nix
    ../../modules/users.nix
    ../../modules/vm.nix
  ];

  networking = {
    networkmanager.enable = true;
    hostName = "senko-desktop";
    nftables.enable = true;

    firewall = {
      enable = true;
      # Always allow traffic from your Tailscale network
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      # Allow the Tailscale UDP port through the firewall
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
      # Force tailscaled to use nftables (Critical for clean nftables-only systems)
      # This avoids the "iptables-compat" translation layer issues.
      tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];

      NetworkManager-wait-online.enable = false;
    };

    # Optimization: Prevent systemd from waiting for network online
    # (Optional but recommended for faster boot with VPNs)
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
