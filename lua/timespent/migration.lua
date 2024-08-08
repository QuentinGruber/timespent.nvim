local local_utils = require("timespent.utils")
local dataprocessing = require("timespent.dataprocessing")
local OLD_DATA_FILE_PROJECTS =
    require("timespent.constants").OLD_DATA_FILE_PROJECTS

local Migration = {}

-- Convert old data to newer format
---@param old_data string -- time in seconds
function Migration.migrate_old_data(old_data)
    local data = dataprocessing.get_data()
    local lines = local_utils.split(old_data, "\n")

    for _, line in ipairs(lines) do
        local parts = local_utils.split(line, ",")
        if #parts >= 2 then -- Ensure there are at least 2 parts
            local path = parts[1]
            local time = parts[2]

            local type = local_utils.get_path_type(path)
            local parent = ""

            if dataprocessing.is_valid_path(path) and type ~= nil then
                dataprocessing.registerEntry(data, path, parent, time, type)
            end
        end
    end
    dataprocessing.save_to_disk(data)
    local_utils.info_log("old data succesfully migrated")
end

function Migration.detect_needed_migration()
    local saved_data = dataprocessing.get_data()
    if #saved_data < 1 then
        local old_data = local_utils.read_file(OLD_DATA_FILE_PROJECTS)
        if old_data ~= nil then
            local_utils.info_log("need to migrate old data")
            Migration.migrate_old_data(old_data)
        end
    end
end
return Migration
