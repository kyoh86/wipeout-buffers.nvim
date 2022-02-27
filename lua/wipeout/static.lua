local buffer = require("wipeout.buffer")
local core = require("wipeout.core")

local M = {}

function M.other(params)
    local current = buffer.current_number()
    core.filtered(params, {
        function(item)
            return item.bufnr ~= current
        end,
    })
end

function M.hidden(params)
    core.filtered(params, {
        function(item)
            return #item.windows == 0
        end,
    })
end

function M.nameless(params)
    core.filtered(params, {
        function(item)
            return item.name == ""
        end,
    })
end

function M.all(params)
    core.filtered(params)
end

function M.current(params)
    core.one(params, buffer.current())
end

return M
