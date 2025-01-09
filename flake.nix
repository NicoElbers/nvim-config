{
  description = "My neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    nixPatch = {
      url = "github:NicoElbers/nixPatch-nvim";
      inputs.nixpkgs.follows = "nixpkgs";

      # We do this so that we ensure neovim nightly actually updates
      inputs.neovim-nightly-overlay.follows = "neovim-nightly-overlay";
    };

    blink = {
      url = "github:Saghen/blink.cmp";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixPatch, blink, ... }@inputs: 
  let
    # Copied from flake utils
    eachSystem = with builtins; systems: f:
        let
        # Merge together the outputs for all systems.
        op = attrs: system:
          let
          ret = f system;
          op = attrs: key: attrs //
            {
              ${key} = (attrs.${key} or { })
              // { ${system} = ret.${key}; };
            }
          ;
          in
          foldl' op attrs (attrNames ret);
        in
        foldl' op { }
        (systems
          ++ # add the current system if --impure is used
          (if builtins ? currentSystem then
             if elem currentSystem systems
             then []
             else [ currentSystem ]
          else []));
    
    forEachSystem = eachSystem nixpkgs.lib.platforms.all;

  in 
  let
    # Easily configure a custom name, this will affect the name of the standard
    # executable, you can add as many aliases as you'd like in the configuration.
    name = "nvimp";

    # Any custom package config you would like to do.
    extra_pkg_config = {
        # allow_unfree = true;
    };

    configuration = { pkgs, system, ... }: 
    let
      lib = pkgs.lib;
      patchUtils = nixPatch.patchUtils.${pkgs.system};

      blink-pkg = blink.packages.${system}.default;
    in 
    {
      # The path to your neovim configuration.
      luaPath = ./.;

      # Plugins you use in your configuration.
      plugins = with pkgs.vimPlugins; [
        # lazy
        lazy-nvim

        # completions
        nvim-cmp
        cmp_luasnip
        luasnip
        friendly-snippets
        cmp-path
        cmp-buffer
        cmp-nvim-lua
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help

        # completions 2
        blink-pkg

        # telescope
        plenary-nvim
        telescope-nvim
        telescope-undo-nvim
        telescope-ui-select-nvim
        telescope-fzf-native-nvim
        todo-comments-nvim
        trouble-nvim

        # Formatting
        conform-nvim

        # lsp
        nvim-lspconfig
        fidget-nvim
        lazydev-nvim
        rustaceanvim
        none-ls-nvim

        nvim-dap # rustaceanvim dep

        # hex
        hex-nvim

        # treesitter
        nvim-treesitter-textobjects
        (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            asm
            bash
            bibtex
            c
            cpp
            css
            html
            http
            javascript
            lua
            make
            markdown
            markdown_inline
            nix
            python
            rust
            toml
            typescript
            vim
            vimdoc
            xml
            yaml
            comment
            diff
            git_config
            git_rebase
            gitcommit
            gitignore
            gpg
            jq
            json
            json5
            llvm
            ssh_config
            zig
          ]
        ))

        # ui
        lualine-nvim
        nvim-web-devicons
        gitsigns-nvim
        nui-nvim
        neo-tree-nvim
        undotree
        oil-nvim

        # Color scheme
        onedark-nvim
        catppuccin-nvim
        tokyonight-nvim

        #misc
        vimtex
        comment-nvim
        vim-sleuth
        indent-blankline-nvim
        markdown-preview-nvim
        markview-nvim
        image-nvim
        autoclose-nvim
      ];

      # Runtime dependencies. This is thing like tree-sitter, lsps or programs
      # like ripgrep.
      runtimeDeps = with pkgs; [
        universal-ctags
        tree-sitter
        ripgrep
        fd
        gcc
        nix-doc

        # lsps
        lua-language-server
        nodePackages_latest.typescript-language-server
        vscode-langservers-extracted
        emmet-language-server
        tailwindcss-language-server
        clang-tools
        nixd
        marksman
        pyright
        gopls
        vhdl-ls

        # Zig sucks bc the LSP is only suported for master
        # inputs.zls.packages.${pkgs.system}.zls

        # Rust
        rust-analyzer
        cargo
        rustc

        # Formatters
        prettierd
        nodePackages_latest.prettier
        stylua
        black
        rustfmt
        checkstyle
        languagetool-rust

        # latex
        texliveFull

        # Clipboard
        wl-clipboard-rs
      ];

      # Environment variables set during neovim runtime.
      environmentVariables = { };

      # Extra wrapper args you want to pass.
      # Look here if you don't know what those are:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = [ ];

      # Extra python packages for the neovim provider.
      # This must be a list of functions returning lists.
      python3Packages = [ ];

      # Wrapper args but then for the python provider.
      extraPython3WrapperArgs = [ ];

      # Extra lua packages for the neovim lua runtime.
      luaPackages = [ ];

      # Extra shared libraries available at runtime.
      sharedLibraries = [ ];

      # Aliases for the patched config
      aliases = [ "nv" "vim" "vi" "nvim" ];

      # Extra lua configuration put at the top of your init.lua
      # This cannot replace your init.lua, if none exists in your configuration
      # this will not be writtern. 
      # Must be provided as a list of strings.
      extraConfig = [ ];

      # Custom subsitutions you want the patcher to make. Custom subsitutions 
      # can be generated using
      customSubs = with pkgs.vimPlugins patchUtils; []
            ++ (patchUtils.githubUrlSub "saghen/blink.cmp" blink-pkg)
            ++ (patchUtils.stringSub "replace_me" "replaced");
            # For example, if you want to add a plugin with the short url
            # "cool/plugin" which is in nixpkgs as plugin-nvim you would do:
            # ++ (patchUtils.githubUrlSub "cool/plugin" plugin-nvim);
            # If you would want to replace the string "replace_me" with "replaced" 
            # you would have to do:
            # ++ (patchUtils.stringSub "replace_me" "replaced")
            # For more examples look here: https://github.com/NicoElbers/nv/blob/main/subPatches.nix

      settings = {
        # Enable the NodeJs provider
        withNodeJs = true;

        # Enable the ruby provider
        withRuby = true;

        # Enable the perl provider
        withPerl = true;

        # Enable the python3 provider
        withPython3 = true;

        # Any extra name 
        extraName = "";

        # The default config directory for neovim
        configDirName = "nvim";

        # Any other neovim package you would like to use, for example nightly
        neovim-unwrapped = inputs.nixPatch.neovim-nightly.${system};

        # Whether to add custom subsitution made in the original repo, makes for
        # a better out of the box experience 
        patchSubs = true;

        # Whether to add runtime dependencies to the back of the path
        suffix-path = false;

        # Whether to add shared libraries dependencies to the back of the path
        suffix-LD = false;
      };
    };
  in 
  forEachSystem (system: {
    packages.default = 
      nixPatch.configWrapper.${system} { inherit configuration extra_pkg_config name; };
  });
}
