{ config, pkgs, lib, ... }:

# let
# kube_ps1 = builtins.fetchGit {
#   name = "kube-ps1";
#   url = "https://github.com/jonmosco/kube-ps1";
#   ref = "refs/tags/v0.8.0";
# };
# in 
{ 
  programs.home-manager.enable = true;
  
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "tioxy";
    homeDirectory = "/home/tioxy";
    stateVersion = "23.11";
    packages = with pkgs; [
      jq
      bat
      htop
      watch
      tree
      wget
      fzf
      _1password

      # nvim
      ripgrep
      fd
      tree-sitter
      nodejs
      unzip
      stylua
      gcc

      awscli2
    ];
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      EDITOR = "nvim";
      PAGER = "less -FirSwX";
      KUBE_PS1_SYMBOL_DEFAULT = "k8s";
    };
  };

  fonts.fontconfig.enable = true;

  # Shell
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "home-manager switch";
      k = "kubectl";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "asdf"
        "kube-ps1"
      ];
      theme = "steeef";
    };
    initExtra = ''
      RPROMPT='$(kube_ps1)'
    '';
  };


  xdg.configFile.nvim = {  
    source = ./nvim;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.lazygit = {
    enable = true;
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
}
