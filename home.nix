{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.username = "jhen";
  home.homeDirectory = "/var/home/jhen";
  home.stateVersion = "25.11"; # Don't change without reading HM release notes

  programs.home-manager.enable = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Any unfree packages have to be specified here
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
    ];

  home.packages = with pkgs; [
    micro # Lightweight text editor
    nil # Nix language server
    nixd # Nix language server
    claude-code # AI coding agent
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Joni Hendrickson";
        email = "contact@joni.site";
      };
      init.defaultBranch = "main";
    };
  };

  # Shell configuration with fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_config theme choose base16-default
      fish_config prompt choose default
    '';
  };

  # Bash stays as login shell; fish is launched for interactive sessions
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  # Add new machines here when I'm done configuring them and update other configs
  services.syncthing = {
    enable = true;
    settings = {
      devices = {
        sumac = {
          id = "AY7LJTM-F5BRYPE-FDCXAGE-AJLP7TU-JW3PRMX-L6HX754-CK3MUGZ-KLEJWAB";
          introducer = true;
        };
        ginger.id = "ROA5SZQ-OA33NRK-2NNBO5R-QVVW3FQ-DBFUWP6-XTQ4UKJ-M2D66T6-UAFPFAQ";
        saffron.id = "T2F7ICT-EMNBQH6-TBDQ4DE-7X7J57J-QCGWIS2-VXBN4HB-LRGNZUZ-AFI5IQF";
      };
      folders."~/0everything" = {
        id = "0everything";
        devices = [
          "sumac"
          "ginger"
          "saffron"
        ];
      };
    };
  };

  # TODO: Only need to enable GUI apps on machines with a screen
  services.flatpak = {
    enable = true;
    update = {
      auto.enable = true;
      onActivation = true;
    };
    packages = [
      {
        appId = "io.gitlab.librewolf-community";
        origin = "flathub";
      }
      {
        appId = "com.bitwarden.desktop";
        origin = "flathub";
      }
      {
        appId = "org.chromium.Chromium";
        origin = "flathub";
      }
      {
        appId = "md.obsidian.Obsidian";
        origin = "flathub";
      }
      {
        appId = "dev.zed.Zed";
        origin = "flathub";
      }
    ];
    # Librewolf needs camera access for video calls
    overrides = {
      "io.gitlab.librewolf-community".Context = {
        devices = [ "all" ];
      };
    };
  };
}
