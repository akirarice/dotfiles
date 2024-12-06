require("nvim-treesitter.configs").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc","python", "html",
    "markdown","markdown_inline"},
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
})
