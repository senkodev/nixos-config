{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.lib.stylix) pixel;
  inherit (config.lib.stylix.colors.withHashtag)
    base00
    base05
    base0D
    ;
  inherit (config.stylix) fonts;

  grubFont =
    font:
    pkgs.runCommand "${font.package.name}.pf2"
      {
        FONTCONFIG_FILE = pkgs.makeFontsConf { fontDirectories = [ font.package ]; };
      }
      ''
        file=$(${lib.getExe' pkgs.fontconfig "fc-match"} ${lib.escapeShellArg font.name} --format=%{file})
        ${lib.getExe' pkgs.grub2 "grub-mkfont"} $file --output $out --size ${toString fonts.sizes.applications}
      '';

  theme =
    pkgs.runCommand "stylix-grub-accent"
      {
        themeTxt = ''
          desktop-image: "background.png"
          desktop-image-scale-method: "crop"
          desktop-color: "${base00}"

          title-text: ""

          terminal-left: "10%"
          terminal-top: "20%"
          terminal-width: "80%"
          terminal-height: "60%"

          + progress_bar {
            left = 25%
            top = 80%+20
            width = 50%
            height = 30

            id = "__timeout__"
            show_text = true
            font = "${fonts.sansSerif.name}"
            text = "@TIMEOUT_NOTIFICATION_MIDDLE@"

            border_color = "${base00}"
            bg_color = "${base00}"
            fg_color = "${base0D}"
            text_color = "${base05}"
          }

          + boot_menu {
            left = 25%
            top = 20%
            width = 50%
            height = 60%
            menu_pixmap_style = "background_*.png"

            item_height = 40
            item_icon_space = 8
            item_spacing = 0
            item_padding = 0
            item_font = "${fonts.sansSerif.name}"
            item_color = "${base05}"

            selected_item_color = "${base00}"
            selected_item_pixmap_style = "selection_*.png"
          }
        '';
        passAsFile = [ "themeTxt" ];
      }
      ''
        mkdir $out
        cp $themeTxtPath $out/theme.txt
        cp ${pixel "base00"} $out/background.png
        cp ${pixel "base01"} $out/background_c.png
        cp ${pixel "base0D"} $out/selection_c.png
        cp ${grubFont fonts.sansSerif} $out/sans_serif.pf2
      '';
in
{
  stylix.targets.grub.enable = false;

  boot = {
    plymouth.enable = true;

    kernelParams = [ "quiet" ];
    initrd.verbose = false;

    loader = {
      systemd-boot.enable = false;
      refind.enable = false;
      efi.canTouchEfiVariables = true;
      timeout = 2;

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        configurationLimit = 10;

        inherit theme;
        backgroundColor = base00;
        splashImage = pixel "base00";
        font = toString (grubFont fonts.monospace);
      };
    };
  };
}
