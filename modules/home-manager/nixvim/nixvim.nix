{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    plugins = {
      telescope.enable = true;
      lualine.enable = true;
      luasnip.enable = true;
      nvim-tree.enable = true;
      treesitter.enable = true;
      lsp = {
        enable = true;
	servers = {
          tsserver.enable = true;
          lua-ls.enable = true;
          #rust-analyzer.enable = true;
          pyright.enable = true;
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
                  elseif luasnip.expandable() then
                    luasnip.expand()
                  elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                  elseif check_backspace() then
                    fallback()
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
