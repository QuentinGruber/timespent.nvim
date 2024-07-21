local local_utils = require("timespent.utils")

local dataprocessing = {}
local constants = require("timespent.constants")
local SavedTime = require("timespent.savedTimeClass")

local uv = vim.uv
function dataprocessing.format(path, time)
    return string.format("%s,%d", path, time)
end
function dataprocessing.get_fd_file()
    return uv.fs_open(constants.DATA_FILE_PROJECTS, "r+", constants.RWD_FS)
end
function dataprocessing.get_data(fd)
    -- TODO: which size to use?
    local raw = uv.fs_read(fd, 2000)
    if raw == nil then
        vim.notify("raw is nil")
    end
    local sttable = {}
    local lines = local_utils.split(raw, "\n")
    for i, line in ipairs(lines) do
        local parts = local_utils.split(line, ",")
        local path = ""
        local time = 0
        for index, value in ipairs(parts) do
            if index == 1 then
                path = value
            elseif index == 2 then
                time = value
            end
        end
        if path ~= "" then
            local st = SavedTime:new(path, time)
            table.insert(sttable, st)
        end
    end
    return sttable
end
function dataprocessing.encode_data(data)
    local encoded_string = ""
    for i, value in ipairs(data) do
        local formattedvalue = dataprocessing.format(value.path, value.time)
        -- TODO: shitty
        encoded_string = string.format("%s\n%s", encoded_string, formattedvalue)
    end
    return encoded_string
end
function dataprocessing.write_new_data(path, time)
    local fd = uv.fs_open(constants.DATA_FILE_PROJECTS, "r+", constants.RWD_FS)
    local exitantData = dataprocessing.get_data(fd)
    local exist = false
    for index, value in ipairs(exitantData) do
        if value.path == path then
            value:addTime(time)
            exist = true
        end
    end
    if exist == false then
        local newsavedtime = SavedTime:new(path, time)
        table.insert(exitantData, newsavedtime)
    end
    local encoded_string = dataprocessing.encode_data(exitantData)
    uv.fs_close(fd)
    fd = uv.fs_open(constants.DATA_FILE_PROJECTS, "w+", constants.RWD_FS)
    uv.fs_write(fd, encoded_string)
    uv.fs_close(fd)
end
return dataprocessing
