-- Pull in the wezterm API
local wezterm = require("wezterm")

local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "TokyoNight Storm"

-- 背景ぼかし
-- config.window_background_opacity = 0.3
config.macos_window_background_blur = 20
config.tab_bar_at_bottom = true

config.font = wezterm.font_with_fallback({
  { family = "FiraCode Nerd Font Mono", weight = "Bold" },
  "Hiragino Sans",
})
config.font_size = 15.0

config.keys = {
  {
    key = "f",
    mods = "CTRL|CMD",
    action = act.ToggleFullScreen,
  },
  {
    key = "d",
    mods = "CMD",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  -- Ctrl+Shift+dで新しいペインを作成(画面を分割)
  {
    key = "d",
    mods = "SHIFT|CMD",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "[",
    mods = "CMD",
    action = act.ActivatePaneDirection("Prev"),
  },
  {
    key = "]",
    mods = "CMD",
    action = act.ActivatePaneDirection("Next"),
  },
  {
    key = "w",
    mods = "CMD",
    action = act.CloseCurrentPane({ confirm = true }),
  },
  {
    key = 'p',
    mods = 'CMD',
    action = wezterm.action.ShowTabNavigator
  },
}

-- and finally, return the configuration to wezterm
return config
