{
  config,
  username,
  ...
}:
let
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/BTccs/ymdW5Z6UzqVHOkwKxqLC0k69cgVJB3UAb/7";
  gitName = "senkodev";
  gitEmail = "me@senko.dev";
in
{
  environment.sessionVariables.XDG_CONFIG_DIRS =
    config.home-manager.users.${username}.xdg.systemDirs.config;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hmbackup";

    users.${username} =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        home = {
          stateVersion = "26.05";
          file.${config.gtk.gtk2.configLocation}.force = lib.mkForce true;
        };

        programs = {
          vscode = {
            enable = true;
            profiles.default = {
              enableUpdateCheck = false;
              enableExtensionUpdateCheck = false;
              userSettings = {
                "telemetry.telemetryLevel" = "off";
                "workbench.enableExperiments" = false;
                "workbench.settings.enableNaturalLanguageSearch" = false;
                "npm.fetchOnlinePackageInfo" = false;
                "update.showReleaseNotes" = false;

                "chat.disableAIFeatures" = true;

                "workbench.colorTheme" = lib.mkForce "AMOLED Black";
                "chat.agent.enabled" = false;
                "terminal.integrated.mouseWheelScrollSensitivity" = 3;
                "terminal.integrated.gpuAcceleration" = "off";
              };
            };
          };

          git = {
            enable = true;

            settings = {
              user = {
                name = gitName;
                email = gitEmail;
              };

              gpg.ssh.allowedSignersFile = toString (
                pkgs.writeText "git-allowed-signers" "${gitEmail} ${signingKey}\n"
              );
            };

            signing = {
              format = "ssh";
              signer = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
              key = signingKey;
              signByDefault = true;
            };
          };

          kitty = {
            enable = true;

            settings = {
              disable_ligatures = "never";

              confirm_os_window_close = 0;
              window_padding_width = 8;
              hide_window_decorations = "no";
              remember_window_size = "yes";
              enable_audio_bell = "no";

              cursor_shape = "beam";
              cursor_blink_interval = "0.5";

              scrollback_lines = 10000;

              tab_bar_style = "powerline";
              tab_powerline_style = "slanted";
            };

            keybindings = {
              "ctrl+shift+t" = "new_tab_with_cwd";
              "ctrl+shift+enter" = "new_window_with_cwd";
              "ctrl+shift+f5" = "load_config_file";
            };
          };

          btop.enable = true;

          hyfetch = {
            enable = true;
            settings = {
              preset = "nonbinary";
              mode = "rgb";
              auto_detect_light_dark = false;
              light_dark = "dark";
              lightness = 0.65;
              color_align.mode = "horizontal";
              backend = "fastfetch";
              distro = null;
              pride_month_disable = false;
              custom_ascii_path = null;
              custom_presets = null;
            };
          };
        };

        gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;

        xdg = {
          configFile = {
            "gtk-3.0/settings.ini".force = true;
            "gtk-3.0/gtk.css".force = true;
            "gtk-4.0/settings.ini".force = true;
            "gtk-4.0/gtk.css".force = true;
          };

          autostart = {
            enable = true;
            entries = [
              "${pkgs._1password-gui}/share/applications/1password.desktop"

              "${
                pkgs.runCommandLocal "trayscale-autostart" { } ''
                  mkdir -p $out
                  substitute \
                    ${pkgs.trayscale}/share/applications/dev.deedles.Trayscale.desktop \
                    $out/dev.deedles.Trayscale.desktop \
                    --replace-fail "Exec=trayscale %F" "Exec=trayscale --hide-window"
                ''
              }/dev.deedles.Trayscale.desktop"
            ];
          };

          systemDirs.config = lib.mkAfter [
            "${pkgs.runCommandLocal "plasma-stylix-defaults"
              {
                kdeglobals = ''
                  [Icons]
                  Theme=${config.stylix.icons.dark}
                '';

                kded6rc = ''
                  [Module-gtkconfig]
                  autoload=false
                '';
              }
              ''
                mkdir "$out"
                printf '%s' "$kdeglobals" >"$out/kdeglobals"
                printf '%s' "$kded6rc" >"$out/kded6rc"
              ''
            }"
          ];
        };
      };
  };
}
