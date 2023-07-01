{ pkgs, ... }:

{
  environment.pathsToLink = [ "/share/fish" ];

  programs.fish.enable = true;

  users.users.root = {
    isSystemUser = true;
    home = "/root";
    extraGroups = [ "wheel" "docker" "audio" ];
    shell = pkgs.fish;
    password = "root";
  };
}
