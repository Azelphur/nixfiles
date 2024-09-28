{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
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
      yazi.enable = true;
      fzf-lua.enable = true;
      precognition = {
        enable = true;
        settings = {
          startVisible = true;
        };
      };
      lsp = {
        enable = true;
        servers = {
          ts-ls.enable = true;
          lua-ls.enable = true;
          pyright.enable = true;
          nil-ls.enable = true;
      	};
      };
      neogen = {
        enable = true;
      	languages = {
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
