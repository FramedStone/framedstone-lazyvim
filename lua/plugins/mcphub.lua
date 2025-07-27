return {
  {
    -- "CopilotC-Nvim/CopilotChat.nvim",
    "deathbeam/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    branch = "tools",
    lazy = false,
    opts = {
      sticky = {
        "$claude-sonnet-4",
        "#files",
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local isReady = false

      chat.setup(opts)

      -- Add optional delay to make sure sticky notes are ready
      vim.defer_fn(function()
        isReady = true
      end, 150)

      -- Safe toggle that waits for sticky init
      vim.g.safeToggleCopilotChat = function()
        if not isReady then
          vim.notify("🕐 CopilotChat is still initializing...", vim.log.levels.WARN)
          return
        end
        chat.toggle()
      end
    end,
    keys = {
      {
        "<leader>aa",
        function()
          vim.g.safeToggleCopilotChat()
        end,
        desc = "CopilotChat: Open",
      },
    },
  },

  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    lazy = false,
    config = function()
      -- Load .env from ~/.config/nvim/.env
      local function loadEnvFile(filePath)
        local file = io.open(filePath, "r")
        if not file then
          return
        end
        for line in file:lines() do
          local key, value = line:match("^%s*([%w_]+)%s*=%s*(.+)%s*$")
          if key and value and os.getenv(key) == nil then
            vim.fn.setenv(key, value)
          end
        end
        file:close()
      end

      local envPath = vim.fn.stdpath("config") .. "/.env"
      loadEnvFile(envPath)

      local figmaToken = os.getenv("FIGMA_TOKEN")
      if not figmaToken then
        vim.notify("⚠️ FIGMA_TOKEN not found in ~/.config/nvim/.env", vim.log.levels.ERROR)
        return
      end

      require("mcphub").setup({
        figmaToken = figmaToken,
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
