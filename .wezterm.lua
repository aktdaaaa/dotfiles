-- Pull in the wezterm API
local wezterm = require("wezterm")

local mux = wezterm.mux

local act = wezterm.action

local home_dir = os.getenv("HOME") or ""

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "TokyoNight Storm"

-- 背景ぼかし
-- config.window_background_opacity = 0.7
config.macos_window_background_blur = 20
config.tab_bar_at_bottom = true

config.font = wezterm.font_with_fallback({
  { family = "FiraCode Nerd Font Mono", weight = "Bold" },
  "Hiragino Sans",
})
config.font_size = 12.0

config.color_scheme = 'Dracula+'
-- Expand ~ manually so wezterm can resolve the background image path.
config.window_background_image = home_dir .. '/Downloads/windows.jpg'
config.window_background_image_hsb = {
  -- Darken the background image by reducing it to 1/3rd
  brightness = 0.1,

  -- You can adjust the hue by scaling its value.
  -- a multiplier of 1.0 leaves the value unchanged.
  hue = 1.0,

  -- You can adjust the saturation also.
  saturation = 1.0,
}

-- Enable audible bell for notifications
config.audible_bell = "SystemBeep"
-- Visual bell as backup (flash the window)
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}
config.colors = {
  visual_bell = '#202020',
}

config.keys = {
  {
    key = "f",
    mods = "CTRL|CMD",
    action = act.ToggleFullScreen,
  },
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action.SendString("\x1b\r"),
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

wezterm.on('gui-startup', function(cmd)
  local home = wezterm.home_dir

  -- ===== ウィンドウ1: 開発サーバー =====
  local tab, server_pane, window = mux.spawn_window {
    cwd = home .. '/miive-server',
  }
  server_pane:send_text 'docker compose up\n'

  local app_pane = server_pane:split {
    direction = 'Right',
    size = 0.66,
    cwd = home .. '/miive-app',
  }
  app_pane:send_text 'yarn dev\n'

  local admin_pane = app_pane:split {
    direction = 'Bottom',
    size = 0.5,
    cwd = home .. '/miive-admin',
  }
  admin_pane:send_text 'yarn dev\n'

  window:gui_window():maximize()

  -- ===== エディタタブ（各プロジェクト別タブ + claude） =====
  local editor_tab1, editor_server_pane = window:spawn_tab {
    cwd = home .. '/miive-server',
  }
  editor_tab1:set_title 'server'
  local claude_server = editor_server_pane:split {
    direction = 'Right',
    size = 0.33,
    cwd = home .. '/miive-server',
  }
  wezterm.sleep_ms(500)
  editor_server_pane:send_text 'nvim\n'
  claude_server:send_text 'claude\n'

  local editor_tab2, editor_app_pane = window:spawn_tab {
    cwd = home .. '/miive-app',
  }
  editor_tab2:set_title 'app'
  local claude_app = editor_app_pane:split {
    direction = 'Right',
    size = 0.33,
    cwd = home .. '/miive-app',
  }
  wezterm.sleep_ms(500)
  editor_app_pane:send_text 'nvim\n'
  claude_app:send_text 'claude\n'

  local editor_tab3, editor_admin_pane = window:spawn_tab {
    cwd = home .. '/miive-admin',
  }
  editor_tab3:set_title 'admin'
  local claude_admin = editor_admin_pane:split {
    direction = 'Right',
    size = 0.33,
    cwd = home .. '/miive-admin',
  }
  wezterm.sleep_ms(500)
  editor_admin_pane:send_text 'nvim\n'
  claude_admin:send_text 'claude\n'
end)
-- and finally, return the configuration to wezterm
return config
