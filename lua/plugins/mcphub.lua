return {
  {
    -- "CopilotC-Nvim/CopilotChat.nvim",
    "deathbeam/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    branch = "tools",
    event = "VeryLazy",
    lazy = false,
    opts = {
      sticky = {
        "$gpt-4.1",
        "@context7",
        "@neovim",
        "@mcphub",
        "@brave-search",
        "#file:.github/copilot-instructions.md",
      },
      window = {
        layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
        width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
        -- Options below only apply to floating windows
        relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
        border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = "Copilot Chat", -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local isReady = false
      -- local isChatOpen = false

      chat.setup(opts)

      -- Add optional delay to make sure sticky notes are ready
      vim.defer_fn(function()
        isReady = true
      end, 150)

      -- local function hasChatHistory()
      --   local historyPath = vim.fn.stdpath("data") .. "//copilotchat_history/default.json"
      --   return vim.fn.filereadable(historyPath) == 1
      -- end

      -- Safe toggle that waits for sticky init
      vim.g.safeToggleCopilotChat = function()
        if not isReady then
          vim.notify("🕐 CopilotChat is still initializing...", vim.log.levels.WARN)
          return
        end

        -- Auto save and load default chat
        -- if not isChatOpen then
        --   if hasChatHistory() then
        --     opts.sticky = {} -- to prevent default sticky note to be appended again
        --     chat.setup(opts)
        --   end
        --   chat.load()
        --   chat.open()
        --   isChatOpen = true
        -- else
        --   chat.save()
        --   chat.close()
        --   isChatOpen = false
        -- end

        chat.toggle()
      end
    end,
    keys = {
      {
        "<leader>aa",
        function()
          vim.g.safeToggleCopilotChat()
        end,
        desc = "CopilotChat: Toogle",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    event = "VerLazy",
    opts = {
      file_types = { "markdown", "copilot-chat" },
    },
    ft = { "markdown", "copilot-chat" },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    event = "VeryLazy",
    lazy = false,
    config = function()
      -- Load .env from ~/.config/nvim/.env
      -- local function loadEnvFile(filePath)
      --   local file = io.open(filePath, "r")
      --   if not file then
      --     return
      --   end
      --   for line in file:lines() do
      --     local key, value = line:match("^%s*([%w_]+)%s*=%s*(.+)%s*$")
      --     if key and value and os.getenv(key) == nil then
      --       vim.fn.setenv(key, value)
      --     end
      --   end
      --   file:close()
      -- end

      -- local envPath = vim.fn.stdpath("config") .. "/.env"
      -- loadEnvFile(envPath)
      --
      -- local figmaToken = os.getenv("FIGMA_API_KEY")
      -- if not figmaToken then
      --   vim.notify("⚠️ FIGMA_API_KEY not found in ~/.config/nvim/.env", vim.log.levels.ERROR)
      --   return
      -- end
      --
      -- local braveKey = os.getenv("BRAVE_API_KEY")
      -- if not braveKey then
      --   vim.notify("⚠️ BRAVE_API_KEY not found in ~/.config/nvim/.env", vim.log.levels.ERROR)
      --   return
      -- end

      require("mcphub").setup({
        extensions = {
          copilotchat = {
            enabled = true,
            convert_tools_to_functions = true, -- Convert MCP tools to CopilotChat functions
            convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
            add_mcp_prefix = false, -- Add "mcp_" prefix to function names
          },
        },
      })
      local chat = require("CopilotChat")
      local mcp = require("mcphub")

      mcp.on("servers_updated", function()
        vim.schedule(function()
          local hub = mcp.get_hub_instance()
          if not hub then
            return
          end

          local async = require("plenary.async")
          local callTool = async.wrap(function(server, tool, input, callback)
            hub:call_tool(server, tool, input, {
              callback = function(res, err)
                callback(res, err)
              end,
            })
          end, 4)

          local accessResource = async.wrap(function(server, uri, callback)
            hub:access_resource(server, uri, {
              callback = function(res, err)
                callback(res, err)
              end,
            })
          end, 3)

          chat.config.functions = chat.config.functions or {}

          -- Clean old mcp entries
          for name, fn in pairs(chat.config.functions) do
            if type(fn.id) == "string" and fn.id:sub(1, 4) == "mcp:" then
              chat.config.functions[name] = nil
            end
          end

          -- Register resources
          for _, resource in ipairs(hub:get_resources()) do
            local name = resource.name:lower():gsub(" ", "_"):gsub(":", "")
            chat.config.functions[name] = {
              id = "mcp:" .. resource.server_name .. ":" .. name,
              uri = resource.uri,
              description = type(resource.description) == "string" and resource.description or "",
              resolve = function()
                local res, err = accessResource(resource.server_name, resource.uri)
                if err then
                  error(err)
                end
                res = res or {}
                local content = res.result and res.result.contents or {}
                local out = {}
                for _, msg in ipairs(content) do
                  if msg.text then
                    table.insert(out, {
                      uri = msg.uri,
                      data = msg.text,
                      mimetype = msg.mimeType,
                    })
                  end
                end
                return out
              end,
            }
          end

          -- Register tools
          for _, tool in ipairs(hub:get_tools()) do
            chat.config.functions[tool.name] = {
              id = "mcp:" .. tool.server_name .. ":" .. tool.name,
              group = tool.server_name,
              description = tool.description,
              schema = tool.inputSchema,
              resolve = function(input)
                local res, err = callTool(tool.server_name, tool.name, input)
                if err then
                  error(err)
                end
                res = res or {}
                local content = res.result and res.result.content or {}
                local out = {}
                for _, msg in ipairs(content) do
                  if msg.type == "text" then
                    table.insert(out, { data = msg.text })
                  elseif msg.type == "resource" and msg.resource and msg.resource.text then
                    table.insert(out, {
                      uri = msg.resource.uri,
                      data = msg.resource.text,
                      mimetype = msg.resource.mimeType,
                    })
                  end
                end
                return out
              end,
            }
          end
        end)
      end)
    end,
  },
}
