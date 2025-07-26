return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest",
  config = function()
    require("mcphub").setup()

    local chat = require("CopilotChat")
    chat.setup()

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
}
