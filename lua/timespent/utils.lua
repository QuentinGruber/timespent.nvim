local utils = {}

-- Function to split a string by a given delimiter
function utils.split(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

function utils.get_current_file()
    return vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
end

function utils.formatTime(timesec)
    local hours = math.floor(timesec / 3600)
    local minutes = math.floor((timesec % 3600) / 60)
    local seconds = timesec % 60

    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function utils.get_uv()
    local v =
        vim.version.parse(vim.fn.system({ "nvim", "-v" }), { strict = false })
    print(v)
    local ge = vim.version.ge(v, "0.9.0")
    print(ge)
    if ge then
        return vim.uv
    else
        return vim.loop
    end
end

local uv = utils.get_uv()
function utils.get_current_dir()
    return uv.cwd()
end

return utils
