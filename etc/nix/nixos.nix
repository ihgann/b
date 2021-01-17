{ config, pkgs, ... }:
let
  secrets = import /b/secrets/secrets.nix;

  burke-ed25519 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIjexceqtvEjM22RZNVwjD6WhtEvVtolIaXnc14zK5Wj burke@darmok";

  callPackage = pkgs.callPackage;

  shell-prompt = callPackage /b/src/shell-prompt { };
  burkeutils = callPackage /b/src/burkeutils { };
  minidev = callPackage /b/src/minidev { };
  gcoreutils = callPackage /b/src/gcoreutils { };
  b = callPackage /b/src/b { };
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    /etc/nixos/networking.nix # generated at runtime by nixos-infect
    <home-manager/nixos>
    ./home.nix
    /b/src/perkeepd.nix
  ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

  environment.systemPackages = with pkgs; [
    b
    home-manager
    perkeep
    burkeutils
    fzf
    gcoreutils
    minidev
    ruby_2_6
    git
    ctags
    htop
    jq
    ripgrep
    shell-prompt
    tree
    zsh
  ];
  environment.shells = [ pkgs.zsh ];

  boot.cleanTmpDir = true;
  boot.loader.grub.device = "nodev";

  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  networking = {
    hostName = "nix";
    nameservers = [ "8.8.8.8" ];
    firewall = {
      allowPing = true;
      enable = true;
      allowedTCPPorts = [ 22 80 443 8448 ];
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [ burke-ed25519 ];
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
  };

  virtualisation.docker.enable = true;

  services.matrix-synapse = {
    enable = true;
    server_name = "libbey.me";
    registration_shared_secret = secrets.synapse.registrationSharedSecret;
    extraConfig = ''
      max_upload_size: "50M"
    '';
  };

  services.nginx = let
    defaultTLS = {
      enableACME = true;
      forceSSL = true;
    };
    redirect = host: {
      enableACME = true;
      addSSL = true;
      globalRedirect = host;
    };
    static = root: defaultTLS // { locations."/" = { root = root; }; };
  in {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    clientMaxBodySize = "10G";

    virtualHosts."pk.tty0.dev" = defaultTLS // {
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://${config.services.perkeepd.listen}";
      };
    };

    virtualHosts."notes.burke.libbey.me" = static (import /b/src/notes {});
    virtualHosts."burke.libbey.me" = static /b/src/burke.libbey.me;
    virtualHosts."libbey.me" = redirect "burke.libbey.me";

    virtualHosts."corinne.rikkelman.com" = static /b/src/corinne.rikkelman.com;
    virtualHosts."rikkelman.com" = redirect "corinne.rikkelman.com";

    virtualHosts."paulklassen.org" = static /b/src/paulklassen.org;

    virtualHosts."duckface.ca" = static /b/src/duckface.ca;

    virtualHosts."tty0.dev" = defaultTLS // {
      locations."/".root = /b/src/tty0.dev;
      locations."/nc19".extraConfig =
        "return 307 https://gist.github.com/burke/694d504be69998dbe4477f80ffa90951;";
    };

  };

  services.perkeepd = {
    enable = true;
    listen = "127.0.0.1:3179";
    baseURL = "https://pk.tty0.dev";
    https = false;
    packRelated = true;
    blobPath = "/data/perkeep/blobs";
    levelDB = "/data/perkeep/index.leveldb";
    identity = secrets.perkeep.identity;
    auth = secrets.perkeep.auth;
    identitySecretRing = secrets.perkeep.identitySecretRing;
    s3 = secrets.perkeep.s3;
    b2 = secrets.perkeep.b2;
  };

  users.users.burke = {
    isNormalUser = true;
    home = "/home/burke";
    description = "Burke Libbey";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ burke-ed25519 ];
  };
}
