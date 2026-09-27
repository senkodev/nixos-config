# senkodev's nixOS config

This is my first ever nixOS config!

Having heard about nixOS for a while, I've decided to tinker around it and finally try it out on my desktop PC. I plan on daily driving this project, and eventually learning to make better configs (lol).

![nixOS rice](/screenshots/rice.png)

## PC specs:

- CPU: AMD Ryzen 9 9950X
- GPU: MSI GeForce RTX 5080 16G GAMING TRIO OC
- MB: ASUS X870 MAX GAMING WIFI7

## What's inside:
- NixOS 26.05 with flakes, kernel 6.18 LTS
- RTX 5080 on open NVIDIA kernel modules
- GRUB, themed by Stylix off the same palette as the desktop
- LUKS full-disk encryption with systemd initrd + Plymouth for GUI passphrase auth
- Helium browser provided as a local package rather than pulling in a 3rd party flake
- [Stylix](modules/stylix.nix) for system-wide theming: AMOLED black palette, Papirus-Dark icons with Catppuccin Mocha folders, JetBrains Mono Nerd Font / Inter
- Home Manager built into the system rebuild, mostly so Stylix can reach Plasma,
  GTK, Qt and kitty
- Various sysadmin tools like libvirt, Docker, Wireshark, ipmitool, mtr, zmap, nmap, etc
- zsh + oh-my-zsh, kitty, 1Password with the SSH agent and Git signing
- [iGPU passthrough](modules/vm.nix) for a Windows VM

## License

MIT.
