{ pkgs, ... }:

{
  environment.pathsToLink = [ "/share/fish" ];

  programs.fish.enable = true;

  users.users.root = {
    isSystemUser = true;
    home = "/root";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    password = "root";
  };
}
