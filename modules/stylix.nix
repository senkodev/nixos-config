{ pkgs, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";

    image = ../wallpapers/main.jpg;

    base16Scheme = {
      scheme = "Dark AMOLED";
      author = "senkodev";

      base00 = "000000"; # background
      base01 = "201a1d"; # lighter background
      base02 = "47383f"; # selection
      base03 = "98848e"; # comments
      base04 = "beb5ba"; # dark foreground
      base05 = "eceaeb"; # foreground
      base06 = "f7f7f7"; # light foreground
      base07 = "ffffff"; # light background

      base08 = "f25b6f"; # red
      base09 = "fd9955"; # orange
      base0A = "f9d51d"; # yellow
      base0B = "58db99"; # green
      base0C = "77d1e7"; # cyan
      base0D = "fc90cf"; # blue slot - pink
      base0E = "cb9af7"; # magenta
      base0F = "bb8b72"; # brown
    };

    icons = {
      enable = true;
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "pink";
      };
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    cursor = {
      package = pkgs.catppuccin-cursors.mochaPink;
      name = "catppuccin-mocha-pink-cursors";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.apple-color-emoji;
        name = "Apple Color Emoji";
      };

      sizes = {
        desktop = 10;
        applications = 11;
        terminal = 11;
        popups = 10;
      };
    };

    opacity = {
      terminal = 0.85;
      popups = 0.9;
      applications = 1.0;
      desktop = 1.0;
    };

    targets.gtksourceview.enable = false;
  };
}
