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
      ];

      shellAliases = {
        vim = "nvim";
        vi = "nvim";
      };

      interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" (
      [] ++ [
        (builtins.readFile ./config.fish)
        "set -g SHELL ${pkgs.fish}/bin/fish"
      ])); 
    };

    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins; [
        # Theme
        dracula-nvim
        nerdcommenter

        # Filetree
        telescope-nvim
        plenary-nvim
        telescope-fzf-native-nvim
        nvim-treesitter
        nvim-web-devicons
        telescope-file-browser-nvim

        # Snippets
        ultisnips
        vim-snippets

        # Start
        vim-startify
       
        # Helpers
        coc-nvim
        nerdcommenter
      ];

      extraConfig = ''
        ${builtins.readFile ./neovim/init.vim} 

        " lua scripts
        " lua << EOF
        " EOF

        " Vim theme
        syntax enable
        colorscheme dracula

        " nercommenter plugin
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
    
        " utilsnips plugin
        let g:UltiSnipsExpandTrigger="<tab>"
        let g:UltiSnipsJumpForwardTrigger="<c-b>"
        let g:UltiSnipsJumpBackwardTrigger="<c-z>"
        let g:UltiSnipsEditSplit="vertical"
      '';
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
    extraGroups = [ "wheel" "root" ];
    shell = pkgs.fish;
    password = "tioxy";
  };
}
