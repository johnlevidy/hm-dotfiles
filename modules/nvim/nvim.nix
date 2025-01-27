# TODO: Once this PR is merged I can get rid of this
{ config, pkgs, lib, ... }:
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
      telescope-ui-select-nvim
      # all for autocomplete
      vim-vsnip
      lspkind-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-vsnip
      cmp-path
      nvim-cmp
      cmp-cmdline
      nvim-lspconfig
      # surround with ys, delete with ds
      nvim-surround
      # file tree
      nvim-tree-lua
      # create missing directories on file save
      mkdir-nvim
      # better navigation
      hop-nvim
      # symbolic outlines
      symbols-outline-nvim
      vim-markdown
      obsidian-nvim
      fidget-nvim
    ];
  };
  xdg.configFile.nvim = {
    recursive = true;
    source = ./.;
  };
}
