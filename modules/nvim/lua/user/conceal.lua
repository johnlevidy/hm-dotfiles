vim.opt.conceallevel = 0

-- Create an autocommand group
vim.api.nvim_create_augroup("MarkdownSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = "MarkdownSettings",
  pattern = "markdown",
  callback = function()
  vim.wo.conceallevel = 2
  end,
})
