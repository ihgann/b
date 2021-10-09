{ config, pkgs, lib, ... }:

let
  callPackage = pkgs.callPackage;

  relativeXDGConfigPath = ".config";
  relativeXDGDataPath = ".local/share";
  relativeXDGCachePath = ".cache";

  minidev = callPackage /b/src/minidev { };

  LS_COLORS = pkgs.fetchgit {
    url = "https://github.com/trapd00r/LS_COLORS";
    rev = "6fb72eecdcb533637f5a04ac635aa666b736cf50";
    sha256 = "0czqgizxq7ckmqw9xbjik7i1dfwgc1ci8fvp1fsddb35qrqi857a";
  };
  ls-colors = pkgs.runCommand "ls-colors" { } ''
    mkdir -p $out/bin $out/share
    ln -s ${pkgs.coreutils}/bin/ls $out/bin/ls
    ln -s ${pkgs.coreutils}/bin/dircolors $out/bin/dircolors
    cp ${LS_COLORS}/LS_COLORS $out/share/LS_COLORS
  '';
in {

    home.packages = [ ls-colors minidev ];

    xdg.enable = true;
    xdg.configHome =
      "/Users/burke/${relativeXDGConfigPath}";
    xdg.dataHome = "/Users/burke/${relativeXDGDataPath}";
    xdg.cacheHome = "/Users/burke/${relativeXDGCachePath}";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    programs.bat.enable = true;
    programs.broot.enable = true;
    programs.gpg.enable = true;

    home.file.".gnupg/gpg-agent.conf".text = ''
    '' + (if pkgs.stdenv.isDarwin then ''
      pinentry-program = ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    '' else
      "");

    home.file.".config/karabiner/karabiner.json".source = ./home/karabiner.json;

    home.file.".crawlrc".source = ./home/crawlrc;

    home.file.".iterm2_shell_integration.zsh".source =
      ./home/.iterm2_shell_integration.zsh;

    home.file.".config/nvim/backup/.keep".text = "";

    home.file.".hammerspoon".source = /b/etc/hammerspoon;
    home.file."Documents/Arduino/Model01-Firmware".source =
      /b/src/Model01-Firmware;

    home.file."Library/LaunchAgents/burke.gitpull.plist".source =
      ./home/burke.gitpull.plist;

    home.file."Library/LaunchAgents/burke.logsync.plist".source =
      ./home/burke.logsync.plist;

    programs.ssh = {
      enable = true;
      extraConfig = ''
        Include ~/.spin/ssh/include
      '';
      # matchBlocks."*" = {
      #   extraOptions = {
      #     UseRoaming = "no";
      #     KexAlgorithms =
      #       "curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256";
      #     HostKeyAlgorithms =
      #       "ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa";
      #     Ciphers =
      #       "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
      #     PubkeyAuthentication = "yes";
      #     MACs =
      #       "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com";
      #     PasswordAuthentication = "no";
      #     ChallengeResponseAuthentication = "no";
      #     # UseKeychain = "yes";
      #     AddKeysToAgent = "yes";
      #   };
      # };

      matchBlocks.tanagra = {
        hostname = "192.168.1.45";
        port = 2222;
        extraOptions = { PasswordAuthentication = "yes"; };
      };
      matchBlocks.nix = { hostname = "138.197.155.9"; };
      matchBlocks.sb = {
        hostname = "144.217.224.247";
        user = "root";
        port = 2222;
      };
    };

    programs.git = {
      enable = true;
      userName = "Burke Libbey";
      userEmail = "burke@libbey.me";
      extraConfig = {
        hub.protocol = "https";
        github.user = "burke";
        color.ui = true;
        pull.rebase = true;
        merge.conflictstyle = "diff3";
        credential.helper = "osxkeychain";
        diff.algorithm = "patience";
        protocol.version = "2";
        core.commitGraph = true;
        gc.writeCommitGraph = true;
        url."https://github.com/Shopify/".insteadOf = [
          "git@github.com:Shopify/"
          "git@github.com:shopify/"
          "ssh://git@github.com/Shopify/"
          "ssh://git@github.com/shopify/"
        ];
      };
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      history = {
        path = "${relativeXDGDataPath}/zsh/.zsh_history";
        size = 50000;
        save = 50000;
      };
      shellAliases = import ./home/aliases.nix;
      defaultKeymap = "emacs";
      initExtraBeforeCompInit = ''
        eval $(${pkgs.coreutils}/bin/dircolors -b ${./home/LS_COLORS})
        ${builtins.readFile ./home/pre-compinit.zsh}
      '';
      initExtra = builtins.readFile ./home/post-compinit.zsh;

      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.6.3";
            sha256 = "1h8h2mz9wpjpymgl2p7pc146c1jgb3dggpvzwm9ln3in336wl95c";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "be3882aeb054d01f6667facc31522e82f00b5e94";
            sha256 = "0w8x5ilpwx90s2s2y56vbzq92ircmrf0l5x8hz4g1nx3qzawv6af";
          };
        }
      ];

      sessionVariables = rec {
        NVIM_TUI_ENABLE_TRUE_COLOR = "1";

        HOME_MANAGER_CONFIG = /b/etc/nix/home.nix;

        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=3";
        DEV_ALLOW_ITERM2_INTEGRATION = "1";

        EDITOR = "vim";
        VISUAL = EDITOR;
        GIT_EDITOR = EDITOR;

        GOPATH = "$HOME";

        PATH = "$HOME/.emacs.d/bin:$HOME/bin:$PATH";
      };
      # envExtra
      # profileExtra
      # loginExtra
      # logoutExtra
      # localVariables
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;
      extraConfig = builtins.readFile ./home/extraConfig.vim;

      plugins = with pkgs.vimPlugins; [
        # Syntax / Language Support ##########################
        vim-nix
        vim-ruby # ruby
        vim-go # go
        vim-fish # fish
        # vim-toml           # toml
        # vim-gvpr           # gvpr
        rust-vim # rust
        zig-vim
        vim-pandoc # pandoc (1/2)
        vim-pandoc-syntax # pandoc (2/2)
        # yajs.vim           # JS syntax
        # es.next.syntax.vim # ES7 syntax

        # UI #################################################
        gruvbox # colorscheme
        vim-gitgutter # status in gutter
        # vim-devicons
        vim-airline

        # Editor Features ####################################
        vim-abolish
        vim-surround # cs"'
        vim-repeat # cs"'...
        vim-commentary # gcap
        # vim-ripgrep
        vim-indent-object # >aI
        vim-easy-align # vipga
        vim-eunuch # :Rename foo.rb
        vim-sneak
        supertab
        # vim-endwise        # add end, } after opening block
        # gitv
        # tabnine-vim
        ale # linting
        nerdtree
        # vim-toggle-quickfix
        # neosnippet.vim
        # neosnippet-snippets
        # splitjoin.vim
        nerdtree

        # Buffer / Pane / File Management ####################
        fzf-vim # all the things

        # Panes / Larger features ############################
        tagbar # <leader>5
        vim-fugitive # Gblame
      ];
    };
}
