local parsers = {
    "lua",
    "rust",
    "cpp",
    "python",
    "javascript",
    "typescript",
    "go",
    "html",
    "css",
    "json",
    "yaml",
    "bash",
    "svelte",
    "tsx",
    "markdown",
    "markdown_inline",
    "typst",
}

local filetypes = {
    "lua",
    "rust",
    "cpp",
    "python",
    "javascript",
    "typescript",
    "go",
    "html",
    "css",
    "json",
    "yaml",
    "bash",
    "svelte",
    "typescriptreact",
    "markdown",
    "typst",
}

return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    branch = "main",

    config = function()
        local ts = require("nvim-treesitter")

        ts.setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        ts.install(parsers)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
            pattern = filetypes,
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)

                vim.bo[args.buf].indentexpr =
                    "v:lua.require'nvim-treesitter'.indentexpr()"

                vim.wo.foldmethod = "expr"
                vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            end,
        })
    end,
}
