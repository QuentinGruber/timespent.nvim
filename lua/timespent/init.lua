local uv = vim.uv
local lastTimeSave = os.time()
local local_utils = require("timespent.utils")
local constants = require("timespent.constants")
local dataprocessing = require("timespent.dataprocessing")

local M = {}

function M.displayTime()
    local fd = uv.fs_open(constants.DATA_FILE_PROJECTS, "r+", constants.RWD_FS)
    local exitantData = dataprocessing.get_data(fd)

    local buf = vim.api.nvim_create_buf(false, true) -- Create a new buffer, not listed, scratch buffer

    local win_width = 100
    local win_height = 20
    local row = math.floor((vim.o.lines - win_height) / 2)
    local col = math.floor((vim.o.columns - win_width) / 2)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "single",
    }

    local buff_lines = {}
    -- Sorting by age in ascending order
    table.sort(exitantData, function(a, b)
        -- TODO: shitty it sould be a number per default and not that
        return tonumber(a.time) > tonumber(b.time)
    end)
    for _, value in ipairs(exitantData) do
        local firstChar = string.sub(value.path, 1, 1)

        if firstChar == "/" then
            local stringtoinsert = string.format(
                "%s, Time: %s",
                value.path:match(".*/(.*)"),
                local_utils.formatTime(value.time)
            )
            table.insert(buff_lines, stringtoinsert)
        end
    end
    vim.api.nvim_open_win(buf, true, opts)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, buff_lines)

    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "q",
        "<Cmd>bd!<CR>",
        { noremap = true, silent = true }
    )
    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "d",
        "",
        { noremap = true, silent = true }
    )
end

function M.registerProgress()
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

function M.init()
    uv.fs_mkdir(constants.NVIM_DATA_FOLDER_PATH, constants.RWD_FS)
    local fd = uv.fs_open(constants.DATA_FILE_PROJECTS, "a", constants.RWD_FS)
    uv.fs_close(fd)
    vim.api.nvim_create_user_command("ShowTime", M.displayTime, {})
    vim.api.nvim_create_autocmd({ "BufLeave", "ExitPre" }, {
        callback = function()
            M.registerProgress()
        end,
    })
end

return M
