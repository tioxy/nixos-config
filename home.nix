{ config, pkgs, lib, ... }:

{ 
  programs.home-manager.enable = true;
  
  nixpkgs.config.allowUnfree = true;

  home = {
    username = "tioxy";
    homeDirectory = "/home/tioxy";
    stateVersion = "23.11";
    packages = with pkgs; [
      htop
      watch
      tree
      wget
      fzf

      # nvim
      ripgrep
      fd
      tree-sitter
      nodejs
      unzip
      stylua
      gcc

      # Personal choices
      jq
      bat
      awscli2
      dive
      _1password
      yq-go
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
      colors = "spectrum_ls";
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
      if [[ $terminfo[colors] -ge 256 ]]; then
          yellow="%F{220}"
          red="%F{160}"
          turquoise="%F{81}"
          orange="%F{208}"
          purple="%F{135}"
          hotpink="%F{161}"
          limegreen="%F{118}"
      else
          yellow="%F{yellow}"
          red="%F{red}"
          turquoise="%F{cyan}"
          orange="%F{yellow}"
          purple="%F{magenta}"
          hotpink="%F{red}"
          limegreen="%F{green}"
      fi

      user_color="$yellow"
      if [[ $USER == "root" ]]; then
        user_color="$red"
      fi

      uname_output="$(uname -a)"
      host_color="$purple"
      if [[ $uname_output == Darwin* ]]; then
        host_color="$orange"
      fi

      PROMPT=$'
      %{$user_color%}%n\$\{PR_RST}@%{$host_color%}%m\$\{PR_RST} %~\$\{PR_RST} $vcs_info_msg_0_$(virtualenv_info) $(kube_ps1)
      $ '
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
