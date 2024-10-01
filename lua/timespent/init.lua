local lastTimeSave = os.time()
local local_utils = require("timespent.utils")
local dataprocessing = require("timespent.dataprocessing")
local ui = require("timespent.ui")
local migration = require("timespent.migration")

local timespent = {}

-- Register time spent on active buffer and active directory
function timespent.registerProgress()
    local currentTime = os.time()
    local diff = os.difftime(currentTime, lastTimeSave)
    local current_file = local_utils.get_current_file()
    local cwd = local_utils.get_current_dir()
    dataprocessing.save_progress(cwd, current_file, diff)
    lastTimeSave = os.time()
end

-- Setup appdata folder, commands and autocmds
function timespent.setup()
    local_utils.setup_appdata()
    migration.detect_needed_migration()

    vim.api.nvim_create_user_command("ShowTimeSpent", ui.displayTime, {})
    vim.api.nvim_create_user_command(
        "ExportTimeSpent",
        dataprocessing.export_csv,
        {}
    )
    vim.api.nvim_create_autocmd({ "BufLeave", "ExitPre" }, {
        callback = function()
            timespent.registerProgress()
        end,
    })
end

return timespent
