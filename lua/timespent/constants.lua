local constants = {}

constants.NVIM_DATA_FOLDER_PATH =
    string.format("%s/timespent", vim.fn.stdpath("data"))
constants.DATA_FILE_PROJECTS =
    string.format("%s/data.json", constants.NVIM_DATA_FOLDER_PATH)
constants.RWD_FS = 448

return constants
