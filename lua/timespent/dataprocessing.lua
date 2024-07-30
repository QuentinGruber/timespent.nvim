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

    local sttable = {}
    local lines = local_utils.split(raw, "\n")

    for _, line in ipairs(lines) do
        local parts = local_utils.split(line, ",")
        if #parts >= 2 then -- Ensure there are at least 2 parts
            local path = parts[1]
            local time = parts[2]

            local st = SavedTime:new(path, time)
            if not st.corrupted then
                table.insert(sttable, st)
            end
        end
    end

    return sttable
end
-- Encode data to the save format
---@param data table -- The data to encode
---@return  string -- The data encoded
function dataprocessing.encode_data(data)
    local encoded_table = {}

    for _, value in ipairs(data) do
        local formatted_value = value:toString()
        table.insert(encoded_table, formatted_value)
    end
    return table.concat(encoded_table, "\n")
end
-- Save / edit a time save entry
---@param path string --
---@param time integer --
function dataprocessing.save_data(path, time)
    local exitantData = dataprocessing.get_data()
    local exist = false
    for _, value in ipairs(exitantData) do
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
    local_utils.write_file(constants.DATA_FILE_PROJECTS, encoded_string)
end
return dataprocessing
