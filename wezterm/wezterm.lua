local wezterm = require 'wezterm'
local c = wezterm.config_builder()
local act = wezterm.action

-- Font & Text
c.font = wezterm.font('Iosevka', {weight='Bold'})
c.font_size = 20
c.line_height = 0.95
c.dpi = 144
c.freetype_load_target = 'Light'
c.freetype_render_target = 'Light'
c.front_end = 'WebGpu'
c.line_height = 0.95

-- Window & Display
c.window_background_opacity = 1
c.dpi = 144
c.max_fps = 144
c.animation_fps = 144
c.term = 'xterm-256color'

-- Misc
c.audible_bell = 'SystemBeep'
c.window_close_confirmation = 'NeverPrompt'

-- Cursor
c.default_cursor_style = 'BlinkingBlock'
c.cursor_blink_ease_in = 'Linear'
c.cursor_blink_ease_out = 'Linear'
c.cursor_blink_rate = 350
c.force_reverse_video_cursor = false

-- Theme
local theme = 'rose-pine-dawn'
local original = wezterm.color.get_builtin_schemes()[theme]
local custom = wezterm.color.get_builtin_schemes()[theme]
custom.selection_bg = original.selection_fg
custom.selection_fg = original.selection_bg
c.color_schemes = {
  ["Custom"] = custom,
}
c.color_scheme = "Custom"

-- Tabs
c.use_fancy_tab_bar = false
c.enable_tab_bar = true
c.show_new_tab_button_in_tab_bar = false
c.hide_tab_bar_if_only_one_tab = true
c.window_close_confirmation = 'NeverPrompt'

-- Bindings
c.mouse_bindings = {
  -- Disable opening hyperlinks
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  -- Open through super+lmb
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'SUPER',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Disable copying from selection
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.Nop,
  },
  {
    event = { Up = { streak = 2, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.Nop,
  },
}

return c
