local local_utils = require("timespent.utils")

local dataprocessing = {}
local constants = require("timespent.constants")
local SavedTime = require("timespent.savedTimeClass")

-- get saved data
function dataprocessing.get_data()
    local raw = local_utils.read_file(constants.DATA_FILE_PROJECTS)
    if not raw then
        error("Failed to read data file: " .. constants.DATA_FILE_PROJECTS)
    end
    -- TODO: do better
    if #raw < 1 then
        return vim.json.decode("[]")
    end
    return vim.json.decode(raw)
end
-- Encode data to the save format
---@param data table -- The data to encode
---@return  string -- The data encoded
function dataprocessing.encode_data(data)
    return vim.json.encode(data)
end
-- Save / edit a time save entry
---@param path string --
---@param time integer --
function dataprocessing.save_data(path, time)
    local exitantData = dataprocessing.get_data()
    local exist = false
    for _, value in ipairs(exitantData) do
        if value.path == path then
            value.time = value.time + time
            exist = true
        end
    end
    if exist == false then
        local newsavedtime = SavedTime:new(path, time)
        table.insert(exitantData, newsavedtime)
    end
    local encoded_string = dataprocessing.encode_data(exitantData)

    local_utils.write_file(constants.DATA_FILE_PROJECTS, encoded_string)
end
return dataprocessing
