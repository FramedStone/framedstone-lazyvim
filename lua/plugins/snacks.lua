return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        pick = function(cmd, opts)
          return LazyVim.pick(cmd, opts)()
        end,
        header = [[
  ______                            _  _____ _                   
 |  ____|                          | |/ ____| |                  
 | |__ _ __ __ _ _ __ ___   ___  __| | (___ | |_ ___  _ __   ___ 
 |  __| '__/ _` | '_ ` _ \ / _ \/ _` |\___ \| __/ _ \| '_ \ / _ \
 | |  | | | (_| | | | | | |  __/ (_| |____) | || (_) | | | |  __/
 |_|  |_|  \__,_|_| |_| |_|\___|\__,_|_____/ \__\___/|_| |_|\___|
                                                                 
                                                                 
 ]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          -- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          -- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          -- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          -- { icon = " ", key = "s", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          -- { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "r", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
  },
}
