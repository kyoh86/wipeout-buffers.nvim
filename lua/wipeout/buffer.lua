local M = {}

--- Get all buffer infos.
---@return wipeout.BufInfo[]
function M.all()
    return vim.fn.getbufinfo()
end

--- Get a current buffer info.
---@return wipeout.BufInfo
function M.current()
    return vim.fn.getbufinfo("%")[1]
end

--- Get a current buffer
---@return buffer
function M.current_number()
    return vim.fn.bufnr("%")
end

--- Get an alternate buffer
---@return buffer
function M.alternate_number()
    return vim.fn.bufnr("#")
end

--- Check a buffer info holds running terminal.
---@return boolean
function M.is_running_terminal(bufinfo)
    local vars = bufinfo["variables"] or {}
    local jobid = vars["terminal_job_id"]
    if not jobid then
        return false
    end
    local ok, pid = pcall(vim.fn.jobpid, jobid)
    return ok and pid == vars["terminal_job_pid"]
end

--- Create filter from wipeout.Params and extra filters
---@param params wipeout.Params
---@param base_filters wipeout.Filter[]? @Extra filters
---@return wipeout.Filter
function M.build_filter(params, base_filters)
    local filters = base_filters or {}
    table.insert(filters, 1, function(bufinfo)
        return bufinfo.listed ~= 0
    end)
    local force = params.force
    if not force then
        table.insert(filters, function(bufinfo)
            return bufinfo.changed == 0
        end)
        table.insert(filters, function(bufinfo)
            return not M.is_running_terminal(bufinfo)
        end)
    end
    local filter = params.filter
    if filter ~= nil then
        table.insert(filters, filter)
    end
    return function(bufinfo)
        for _, f in ipairs(filters) do
            if not f(bufinfo) then
                return false
            end
        end
        return true
    end
end

return M
