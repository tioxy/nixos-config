{ pkgs, home-manager, lib, ... }:

{
  environment.pathsToLink = [ "/share/fish" "/libexec" ];

  home-manager.users.tioxy = { pkgs, ... }: {
    home = {
      stateVersion = "23.05";
      packages = with pkgs; [
        jq
        bat
        htop
        watch
        tree
        ripgrep # telescope
        fd # telescope
        nodejs # coc.nvim
        zig
        wget
        fzf

        # k8s
        kubectl
        kind

        # helm
        kubernetes-helm
        kubernetes-helmPlugins.helm-s3
        kubernetes-helmPlugins.helm-git
        kubernetes-helmPlugins.helm-diff
        helmfile
        helm-docs

        # cloud
        awscli2
      ];
      sessionVariables = {
        LANG = "en_US.UTF-8";
        LC_CTYPE = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        EDITOR = "nvim";
        PAGER = "less -FirSwX";
      };
    };

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/Keys/git.pem";
          extraOptions = {
            UseKeychain = "yes";
            AddKeysToAgent = "yes";
            IgnoreUnknown = "UseKeychain";
          };
        };
      };
    };

    xdg.configFile."i3/config".text = builtins.readFile ./i3;

    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          blocks = [
            {
               block = "disk_space";
               path = "/";
               info_type = "available";
               interval = 10;
               warning = 20.0;
               alert = 10.0;
            }
            {
              block = "cpu";
              interval = 1;
            }
            {
              block = "memory";
              interval = 1;
              warning_mem = 70;
              critical_mem = 90;
            }
            {
              block = "load";
              interval = 1;
              format = " $icon $1m ";
            }
            {
              block = "sound";
            }
            {
              block = "time";
              interval = 60;
              format = " $timestamp.datetime(f:'%a %d/%m %R') ";
            }
          ];
          icons = "awesome6";
          theme = "srcery";
        };
      };
    };

    programs.kitty = {
      enable = true;
      extraConfig = builtins.readFile ./kitty;
      font = {
        name = "MesloLGS Nerd Font Mono";
      };
    };

    programs.fish = {
      enable = true;
      plugins = [
        { name = "tide"; src = pkgs.fishPlugins.tide.src; }
        { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
        { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
        { name = "done"; src = pkgs.fishPlugins.done.src; }
      ];

      shellAliases = {
        vim = "nvim";
        vi = "nvim";
      };

      interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" (
      [] ++ [
        (builtins.readFile ./fish/done.fish)
        (builtins.readFile ./fish/tide.fish)
        (builtins.readFile ./fish/config.fish)
        "set -g SHELL ${pkgs.fish}/bin/fish"
      ])); 
    };

    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        # Theme
        {
          plugin = nord-nvim;
          type = "lua";
          config = builtins.readFile(./neovim/nord.lua);
        }

        # Filetree
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = builtins.readFile(./neovim/nvim-tree.lua);
        }
        {
          plugin = telescope-nvim;
          type = "lua";
          config = builtins.readFile(./neovim/telescope.lua);
        }
        telescope-fzf-native-nvim
        telescope-file-browser-nvim

        # Syntax highligh
        nvim-treesitter
        nvim-treesitter-parsers.go
        nvim-treesitter-parsers.java
        nvim-treesitter-parsers.json
        nvim-treesitter-parsers.python
        nvim-treesitter-parsers.yaml

        # Snippets
        {
          plugin = ultisnips;
          config = ''
            let g:UltiSnipsExpandTrigger="<tab>"
            let g:UltiSnipsJumpForwardTrigger="<c-b>"
            let g:UltiSnipsJumpBackwardTrigger="<c-z>"
            let g:UltiSnipsEditSplit="vertical"
          '';
        }
        vim-snippets

        # Start
        vim-startify

        # Tab/Status bars
        {
          plugin = barbar-nvim;
          type = "lua";
          config = builtins.readFile(./neovim/barbar.lua);
        }
        vim-airline
        {
          plugin = vim-airline-themes;
          type = "lua";
          config = builtins.readFile(./neovim/airline-themes.lua);
        }

        # Code completion
        coc-nvim
        coc-snippets
        telescope-coc-nvim
        coc-git
        coc-go
        coc-java
        coc-json
        coc-python
        coc-yaml

        # Helpers
        gitsigns-nvim # barbar
        nvim-web-devicons
        plenary-nvim # telescope
        vim-gitgutter
        {
          plugin = mini-nvim;
          type = "lua";
          config = builtins.readFile(./neovim/mini.lua);
        }
        nerdcommenter
        {
          plugin = nerdcommenter;
          config = ''
             filetype plugin on
             let g:NERDCreateDefaultMappings = 1
             let g:NERDSpaceDelims = 1
             let g:NERDCompactSexyComs = 1
             let g:NERDDefaultAlign = 'left'
             let g:NERDAltDelims_java = 1
             let g:NERDAltDelims_go = 1
             let g:NERDAltDelims_py = 1
             let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
             let g:NERDCommentEmptyLines = 1
             let g:NERDTrimTrailingWhitespace = 1
             let g:NERDToggleCheckAllLines = 1
          '';
        }
      ];

      extraConfig = builtins.readFile(./neovim/init.vim);
    };

    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
      defaultCacheTtl = 31536000;
      maxCacheTtl = 31536000;
    };

    programs.git = {
      enable = true;
      userName = "Gabriel Tiossi";
      userEmail = "gabrieltiossi@gmail.com";
      aliases = {
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        root = "rev-parse --show-toplevel";
      };
      extraConfig = {
        branch.autosetuprebase = "always";
        color.ui = true;
        core.askPass = "";
        core.fileMode = false;
        credential.helper = "store";
        github.user = "tioxy";
        push.default = "tracking";
        init.defaultBranch = "main";
        safe.directory = ["*"];
      };
    };
  };

  users.users.tioxy = {
    isNormalUser = true;
    home = "/home/tioxy";
    extraGroups = [ "root" "wheel" "docker" "audio" ];
    shell = pkgs.fish;
    password = "tioxy";
  };
}
