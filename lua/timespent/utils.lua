local utils = {}
local constants = require("timespent.constants")

local uv
-- Doing so we support older versions of neovim
if vim.uv then
    uv = vim.uv
else
    uv = vim.loop
end
-- Function to split a string by a given delimiter
---@param input string       -- The string to be split
---@param delimiter string   -- The delimiter to split the string by
---@return table             -- The result table containing the split parts
function utils.split(input, delimiter)
    local result = {}
    for match in (input .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

---@return string -- The current file
function utils.get_current_file()
    return vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
end

-- Format time ( in sec ) to hh:mm:ss
---@param timesec integer -- time in seconds
---@return  string  -- time string in hh:mm:ss
function utils.formatTime(timesec)
    local hours = math.floor(timesec / 3600)
    local minutes = math.floor((timesec % 3600) / 60)
    local seconds = timesec % 60

    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function utils.get_current_dir()
    return uv.cwd()
end
function utils.error_log(data)
    print(data)
end

-- Create the timespent folder and files if they doesn't exists
function utils.setup_appdata()
    uv.fs_mkdir(constants.NVIM_DATA_FOLDER_PATH, constants.RWD_FS)
    local fd = uv.fs_open(constants.DATA_FILE_PROJECTS, "a", constants.RWD_FS)
    uv.fs_close(fd)
end

-- Read the whole file available at {path}
---@param path string -- the path to read
function utils.read_file(path)
    local fd = uv.fs_open(path, "r+", constants.RWD_FS)
    local file_info = uv.fs_fstat(fd)
    if file_info == nil then
        utils.error_log("file info is nil")
        return
    end
    local file_size = file_info.size
    local raw = uv.fs_read(fd, file_size)
    uv.fs_close(fd)
    if raw == nil then
        utils.error_log("raw is nil")
        return
    end
    return raw
end
-- Write file in w+ mode
---@param path string -- the path to write
---@param data string -- the data to write
function utils.write_file(path, data)
    local fd = uv.fs_open(path, "w+", constants.RWD_FS)
    uv.fs_write(fd, data)
    uv.fs_close(fd)
end
return utils
