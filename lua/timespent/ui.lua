local local_utils = require("timespent.utils")
local dataprocessing = require("timespent.dataprocessing")

local UI = {}

function UI.insert_dir_line(buff_lines, value)
    local stringtoinsert = string.format(
        "* %s, Time: %s",
        value.path:match(".*[\\/](.*)"),
        local_utils.formatTime(value.time)
    )
    table.insert(buff_lines, stringtoinsert)
end

function UI.insert_file_line(buff_lines, value)
    local stringtoinsert = string.format(
        "--- %s, Time: %s",
        value.path:gsub(value.parent, ""),
        local_utils.formatTime(value.time)
    )
    table.insert(buff_lines, stringtoinsert)
end

function UI.get_buffer_lines()
    local exitantData = dataprocessing.get_data()
    local dirData = {}
    for _, value in ipairs(exitantData) do
        if value.type == "dir" then
            value.childs = {}
            for _, child in ipairs(exitantData) do
                if child.parent == value.path then
                    table.insert(value.childs, child)
                end
            end
            table.sort(value.childs, function(a, b)
                return a.time > b.time
            end)
            table.insert(dirData, value)
        end
    end
    table.sort(dirData, function(a, b)
        return a.time > b.time
    end)
    local buff_lines = {}
    for _, value in ipairs(dirData) do
        UI.insert_dir_line(buff_lines, value)
        for _, child in ipairs(value.childs) do
            UI.insert_file_line(buff_lines, child)
        end
    end
    return buff_lines
end

-- Create and open a floating buffer
function UI.open_buffer()
    local buffer = vim.api.nvim_create_buf(false, true) -- Create a new buffer, not listed, scratch buffer

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
    vim.api.nvim_open_win(buffer, true, opts)
    UI.apply_buffer_keymaps(buffer)
    return buffer
end

-- Disable a keymap for a given buffer
---@param buffer integer --
---@param mode string --
---@param key string --
function UI.disable_key(buffer, mode, key)
    vim.api.nvim_buf_set_keymap(
        buffer,
        mode,
        key,
        "",
        { noremap = true, silent = true }
    )
end

-- Set an exit key for a buffer
---@param buffer integer --
---@param mode string --
---@param key string --
function UI.set_exit_key(buffer, mode, key)
    vim.api.nvim_buf_set_keymap(
        buffer,
        mode,
        key,
        "<Cmd>bd!<CR>",
        { noremap = true, silent = true }
    )
end

-- Apply custom keymaps to a buffer
---@param buffer integer --
function UI.apply_buffer_keymaps(buffer)
    UI.set_exit_key(buffer, "n", "q")
    UI.set_exit_key(buffer, "n", "<C-h>")
    UI.set_exit_key(buffer, "n", "<C-l>")
    UI.disable_key(buffer, "n", "d")
    UI.disable_key(buffer, "n", "i")
    UI.disable_key(buffer, "n", "v")
    UI.disable_key(buffer, "n", "r")
    UI.disable_key(buffer, "n", "u")
    UI.disable_key(buffer, "n", "<C-r>")
end

-- Display a floating buffer with time spent info on it
function UI.displayTime()
    local buffer = UI.open_buffer()
    local buff_lines = UI.get_buffer_lines()
    vim.api.nvim_buf_set_lines(buffer, 0, -1, false, buff_lines)
end

return UI
