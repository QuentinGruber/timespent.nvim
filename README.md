# timespent.nvim

This project is in WIP and we'll see if I push the idea further with a better display, sorting functions, data export etc...

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

| Command          | Description                                                   |
| ---------------- | ------------------------------------------------------------- |
| `:ShowTimeSpent` | Opens a floating buffer showing where you've spent your time. |

## Planned features

- [ ] min and max save interval options
- [ ] lualine support
- [ ] fullscreen mode
- [ ] filter / sort from buffer
- [ ] data edition from buffer
- [ ] csv data export
- [ ] better ui
