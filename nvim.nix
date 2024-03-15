-- TODO: Once this PR is merged I can get rid of this
{ config, pkgs, lib, ... }:
let
  myHop = pkgs.vimUtils.buildVimPlugin {
    name = "myHop";
    src = /home/john/Code/hop.nvim;
  };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      nvim-treesitter.withAllGrammars
      lualine-nvim
      guess-indent-nvim
      gruvbox-nvim
      # telescope
      telescope-nvim
      plenary-nvim
      telescope-fzf-native-nvim
      # all for autocomplete
      vim-vsnip
      lspkind-nvim
      cmp-nvim-lsp
      cmp-vsnip
      cmp-path
      nvim-cmp
      nvim-lspconfig
      # surround with ys, delete with ds
      nvim-surround
      # file tree
      nvim-tree-lua
      # create missing directories on file save
      mkdir-nvim
      # better navigation
      # hop-nvim
      myHop
      # symbolic outlines
      symbols-outline-nvim
    ];
  };
  xdg.configFile.nvim = {
    recursive = true;
    source = ./nvim;
  };
}
