vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.py*",
    callback = function()
        vim.api.nvim_buf_set_lines(0, 0, 0, false, { "#!/usr/bin/env python3", "" })
    end,
    desc = "Inserted Python shebang for new Python files",
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "/home/akira/.config/rofi/config.rasi",
    command = "set filetype=css",
    desc = "css turned on for rofi config",
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "/home/akira/.config/waybar/style.css,/home/akira/.config/waybar/config.jsonc",
    callback = function()
    os.execute("pkill -USR2 waybar")
    print("Waybar reloaded after editing waybar config files")
    end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "/home/akira/.config/newsboat/urls",
    callback = function()
    os.execute("/home/akira/.local/bin/archAlerts.sh && pkill -RTMIN+9 waybar")
    print("newsboat rss feed updated")
    end,
})
