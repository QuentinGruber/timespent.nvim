local lastTimeSave = os.time()
local local_utils = require("timespent.utils")
local constants = require("timespent.constants")
local dataprocessing = require("timespent.dataprocessing")
local ui = require("timespent.ui")

local uv = local_utils.get_uv()
local timespent = {}

function timespent.registerProgress()
    local currentTime = os.time()
    local diff = os.difftime(currentTime, lastTimeSave)
    local current_file = local_utils.get_current_file()
    local cwd = local_utils.get_current_dir()
    dataprocessing.write_new_data(cwd, diff)
    if currentTime ~= "" then
        dataprocessing.write_new_data(current_file, diff)
    end
    lastTimeSave = os.time()
end

function timespent.init()
    uv.fs_mkdir(constants.NVIM_DATA_FOLDER_PATH, constants.RWD_FS)
    local fd = uv.fs_open(constants.DATA_FILE_PROJECTS, "a", constants.RWD_FS)
    uv.fs_close(fd)
    vim.api.nvim_create_user_command("ShowTimeSpent", ui.displayTime, {})
    vim.api.nvim_create_autocmd({ "BufLeave", "ExitPre" }, {
        callback = function()
            timespent.registerProgress()
        end,
    })
end

return timespent
