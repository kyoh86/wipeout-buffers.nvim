local function get_param(params, key, default)
    if params == nil or type(params) ~= "table" or vim.tbl_islist(params) then
        return default
    elseif not vim.fn.has_key(params, key) then
        return default
    end
    return params[key]
end

local function normalize_params(params)
    return {
        force = get_param(params, "force", false),
        keep_layout = get_param(params, "keep_layout", false),
        filter = get_param(params, "filter", nil),
        debug = get_param(params, "debug", false),
    }
end

local M = {}

local static = require("wipeout.static")
local active = require("wipeout.active")
local exports = vim.tbl_extend("force", static, active)

for key, met in pairs(exports) do
    M[key] = function(params)
        met(normalize_params(params))
    end
end

return M
