{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    clipboard = {
      providers = {
        wl-copy.enable = true;
      };
      register = "unnamedplus";
    };
    keymaps = [
      {
        mode = "n";
        key = "<C-n>";
        options = {
          silent = true;
          noremap = true;
        };
        action = ":lua require('fzf-lua').files()<CR>";
      }
      {
        mode = "n";
        key = "gd";
        options = {
          silent = true;
          noremap = true;
        };
        action = ":lua vim.lsp.buf.definition()<CR>";
      }
    ];
    plugins = {
      telescope.enable = true;
      lualine.enable = true;
      luasnip.enable = true;
      nvim-tree.enable = true;
      treesitter.enable = true;
      fzf-lua.enable = true;
      web-devicons.enable = true;
      precognition = {
        enable = true;
        settings = {
          startVisible = true;
        };
      };
      lsp = {
        enable = true;
        servers = {
          lua_ls.enable = true;
          pyright.enable = true;
          nil_ls.enable = true;
        };
      };
      neogen = {
        enable = true;
        settings.languages = {
          python = {
            template = {
              annotation_convention = "reST";
            };
          };
        };
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "path";}
            {name = "buffer";}
          ];
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = ''
                function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end
              '';
          };
        };
      };
    };
    opts = {
      relativenumber = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-suda
    ];
  };
}
