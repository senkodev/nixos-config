{ pkgs, config, ... }:
let
  sddmTheme = pkgs.runCommand "sddm-breeze-wallpaper" { } ''
    theme=$out/share/sddm/themes/breeze-wallpaper
    mkdir -p "$(dirname "$theme")"
    cp -r ${pkgs.kdePackages.plasma-desktop}/share/sddm/themes/breeze "$theme"
    chmod -R u+w "$theme"

    grep -q '^background=' "$theme/theme.conf"
    sed -i "s|^background=.*|background=${config.stylix.image}|" "$theme/theme.conf"
  '';
in
{
  console.useXkbConfig = true;

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us,ua,ru";
        variant = "";
        options = "grp:alt_shift_toggle";
      };
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "breeze-wallpaper";
    };

    desktopManager.plasma6.enable = true;
  };

  environment = {
    systemPackages = [ sddmTheme ];
    plasma6.excludePackages = with pkgs.kdePackages; [ konsole ];
  };
}
