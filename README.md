# timespent.nvim

Display time spent on projects / files

- install using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
  {
    "quentingruber/timespent.nvim",
    keys = {
      { "<leader>ts", "<cmd>:ShowTimeSpent<cr>", mode = { "n" }, desc = "Show time spent" },
    },
  },
```

## Usage

| Command            | Description                                                   |
| ------------------ | ------------------------------------------------------------- |
| `:ShowTimeSpent`   | Opens a floating buffer showing where you've spent your time. |
| `:ExportTimeSpent` | Export your data to csv                                       |

## Planned features

- [ ] min and max save interval options
- [ ] lualine support
- [ ] fullscreen mode
- [ ] filter / sort from buffer
- [ ] data edition from buffer
- [x] csv data export
- [ ] better ui
