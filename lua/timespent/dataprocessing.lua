local local_utils = require("timespent.utils")

local dataprocessing = {}
local constants = require("timespent.constants")
local SavedTime = require("timespent.savedTimeClass")

-- get saved data
---@return table --
function dataprocessing.get_data()
    local raw = local_utils.read_file(constants.DATA_FILE_PROJECTS)
    if not raw then
        error("Failed to read data file: " .. constants.DATA_FILE_PROJECTS)
    end
    if #raw < 1 then
        return {}
    end
    return vim.json.decode(raw)
end
-- Encode data to the save format
---@param data table -- The data to encode
---@return  string -- The data encoded
function dataprocessing.encode_data(data)
    return vim.json.encode(data)
end

-- register or update an entry
---@param data table --
---@param path string --
---@param parent string --
---@param time integer --
---@param type string --
function dataprocessing.registerEntry(data, path, parent, time, type)
    local exist = false
    for _, value in ipairs(data) do
        if value.path == path then
            value.time = value.time + time
            if value.parent == "" then
                value.parent = parent
            end
            exist = true
        end
    end
    if exist == false then
        local newsavedtime = SavedTime:new(path, time, type, parent)
        table.insert(data, newsavedtime)
    end
end

-- check if the provided path is valid
---@param path string --
function dataprocessing.is_valid_path(path)
    return path ~= "" and path:sub(0, 7) ~= "term://"
end

-- Save data table to disk
---@param data table --
function dataprocessing.save_to_disk(data)
    local encoded_string = dataprocessing.encode_data(data)

    local_utils.write_file(constants.DATA_FILE_PROJECTS, encoded_string)
end

-- Save progress
---@param cwd string --
---@param currentFile string --
---@param time integer --
function dataprocessing.save_progress(cwd, currentFile, time)
    local data = dataprocessing.get_data()
    if dataprocessing.is_valid_path(currentFile) then
        dataprocessing.registerEntry(data, currentFile, cwd, time, "file")
    end
    dataprocessing.registerEntry(data, cwd, "", time, "dir")
    dataprocessing.save_to_disk(data)
end
return dataprocessing
