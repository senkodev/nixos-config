{
  pkgs,
  username,
  ...
}:
{
  boot = {
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
    ];

    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];

    extraModprobeConfig = ''
      options vfio-pci ids=1002:13c0,1002:1640
      softdep amdgpu pre: vfio-pci

      options kvm_amd nested=1
    '';
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
    };
  };
  programs.virt-manager.enable = true;

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 ${username} qemu-libvirtd -"
  ];

  environment.systemPackages = with pkgs; [ looking-glass-client ];
}
