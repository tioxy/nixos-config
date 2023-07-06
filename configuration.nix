# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./machines/vm-shared.nix
      ./machines/vm-aarch64.nix
      ./users/tioxy/nixos.nix
      ./users/root/nixos.nix
    ];
}

