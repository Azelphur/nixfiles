{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    plugins = {
      telescope.enable = true;
      lualine.enable = true;
      luasnip.enable = true;
      nvim-tree.enable = true;
      lsp = {
        enable = true;
	servers = {
          tsserver.enable = true;
          lua-ls.enable = true;
          #rust-analyzer.enable = true;
          pyright.enable = true;
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
