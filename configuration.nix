# This is a NixOS configuration file for a simple
# web service running the cardano.beer website.
# Find more at http://cardano.beer/

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

  # Boot loader configuration
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  # Networking
  networking.hostName = "cardano.beer";
  networking.firewall.enable = false;

  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
    wget vim git nix-prefetch-git 
  ];

  # Enable the OpenSSH daemon
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  # User management
  users.extraUsers.mmahut = {
    isNormalUser = true;
    home = "/home/mmahut";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJD9Xy+A/w7bsCfPCNCX2ycDPOT6NN/qoIfKsCDNrolM/11Vh8NHHovfxxvG94ySaJdo7ZjDdjNM3tXpWdjNEpY8KGxxUX90UydPUnvvSKWnGqLj/SjzPlijG9QxKJyRWd7duHIVeXOeDWwpaOS3YgHAhj4diCLu5Fx8ipZjoG/k/O4hcbJNySasVz8PYTyc6NwS3xPVA+lUgTC5FRGvSh+AJjjnXSZNNQbbx3Hij3K1/X8jaHniRRPC3mafS93DxWeAR1F9fFQUHflAFDm4mSO6fXo8Idw+wO1WGTlOs5z+T4gHUaz3oMaEPz+cRlUQ+Zw+nUo/AWbtCgBMNPKss7 cardno:000607068881" ];
  };

  # Web service
  services.nginx = {
    enable = true;
    virtualHosts."cardano.beer" = {
      root = pkgs.fetchFromGitHub {
        owner = "mmahut";
        repo = "cardano.beer";
        rev = "3c69b2bd0a9abcf55632d2c69968e719d84960c3";
        sha256 = "0j56wf8xxx3c9xfamiykkcayccram2v06265b9bfzymzh624d9xf";
      };
    };
  };

  system.stateVersion = "17.09";

}
