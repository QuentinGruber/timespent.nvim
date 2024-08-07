local lastTimeSave = os.time()
local local_utils = require("timespent.utils")
local dataprocessing = require("timespent.dataprocessing")
local ui = require("timespent.ui")

local timespent = {}

-- Register time spent on active buffer and active directory
function timespent.registerProgress()
    local currentTime = os.time()
    local diff = os.difftime(currentTime, lastTimeSave)
    local current_file = local_utils.get_current_file()
    local cwd = local_utils.get_current_dir()
    -- TODO: make one call
    dataprocessing.save_data(cwd, diff)
    if current_file ~= "" then
        dataprocessing.save_data(current_file, diff)
    end
    lastTimeSave = os.time()
end

-- Setup appdata folder, commands and autocmds
function timespent.setup()
    local_utils.setup_appdata()
    vim.api.nvim_create_user_command("ShowTimeSpent", ui.displayTime, {})
    -- TODO: debug stuff to remove
    vim.api.nvim_create_user_command(
        "RegisterProgress",
        timespent.registerProgress,
        {}
    )
    vim.api.nvim_create_autocmd({ "BufLeave", "ExitPre" }, {
        callback = function()
            timespent.registerProgress()
        end,
    })
end

return timespent
