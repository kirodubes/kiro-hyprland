-- ════════════════════════════════════════════════════════════════════════
-- Kiro Hyprland baseline config  (hyprland.lua)
-- ════════════════════════════════════════════════════════════════════════
-- Target: Hyprland 0.55+ (Lua config format; hyprlang/.conf deprecated in 0.55).
-- Lives at: ~/.config/hypr/hyprland.lua
--
-- Modeled on Omarchy's current Lua config (the modern mainline reference) but
-- carrying Kiro/ArcoLinux's SUPER-based keybind philosophy. Uses ONLY the native
-- hl.* API (no Omarchy o.* helper layer), so it is self-contained.
--
-- API reference: https://wiki.hypr.land/Configuring/Start/
-- Variables:     https://wiki.hypr.land/Configuring/Basics/Variables/
-- Window rules:  https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- ────────────────────────────────────────────────────────────────────────

local mod = "SUPER"

-- Kiro app defaults — adjust to the shipped Kiro toolset.
local term     = "alacritty"
local files    = "thunar"
local browser  = "firefox"
local editor   = "code"
local menu     = "rofi -show drun"
local logout   = "archlinux-logout"   -- Kiro logout dialog (archlinux-logout-gtk4), as on the other editions
local powermenu = "kiro-powermenu"
local lock     = "hyprlock"
local keybindings = "alacritty --class keybindings -e less ~/.config/hypr/keybindings.txt"

-- ── Environment ──────────────────────────────────────────────────────────
-- Force Wayland across toolkits; advertise the session to portals/screenshare.
hl.env("XCURSOR_SIZE", "12")
hl.env("HYPRCURSOR_SIZE", "12")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- VM compatibility (VirtualBox/VMware): hardware cursors + hardware rendering are broken in
-- VMs. Without these, enabling VM "3D acceleration" black-screens Hyprland. Harmless on real
-- hardware (ALLOW_SOFTWARE only permits a fallback; it still uses the GPU when present).
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")

-- ── Monitors & scaling ─────────────────────────────────────────────────────
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/  (`hyprctl monitors` to list).
-- Default: every output, preferred mode, auto position, scale 1 (good for 1080p/1440p).
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
hl.env("GDK_SCALE", "1")
-- HiDPI: bump both for crisp scaling, e.g.
--   retina 2x (13" 2.8K / 27" 5K):  scale = 2    + GDK_SCALE 2
--   27"/32" 4K (fractional):        scale = 1.6  + GDK_SCALE 1.75
-- Portrait/rotated secondary: add transform = 1 (90°) or 3 (270°) to the spec.

-- ── Look & feel ────────────────────────────────────────────────────────────
local active_border   = { colors = { "rgba(7aa2f7aa)", "rgba(c4a7e7aa)" }, angle = 45 }
local inactive_border = "rgba(414868aa)"

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 7,
    border_size = 2,
    col = {
      active_border = active_border,
      inactive_border = inactive_border,
    },
    layout = "master",            -- Kiro/ArcoLinux default; "dwindle" also available
    resize_on_border = true,
    extend_border_grab_area = 5,
    allow_tearing = false,
  },

  decoration = {
    rounding = 5,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
    -- Inner glow on the focused window (0.55+) — Kiro blue accent; off when unfocused.
    glow = {
      enabled = true,
      range = 8,
      render_power = 3,
      color = "rgba(7aa2f7cc)",
      color_inactive = "rgba(00000000)",
    },
  },

  dwindle = {
    preserve_split = true,
    -- pseudotile removed in 0.55 (was a no-op); use the `pseudo` dispatcher instead.
  },

  master = {
    new_status = "master",
    mfact = 0.5,
  },

  input = {
    kb_layout = "be,us",          -- Belgian + US (add kb_options grp:alts_toggle to switch layouts)
    kb_options = "compose:caps",  -- Caps Lock acts as Compose key
    repeat_rate = 40,
    repeat_delay = 600,
    follow_mouse = 1,
    numlock_by_default = true,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      drag_lock = true,
      disable_while_typing = true,
    },
  },

  -- NOTE: the old `gestures { workspace_swipe }` keys were removed in Hyprland 0.51
  -- (replaced by the configurable `gesture` syntax). Swipe was disabled here, so the
  -- block is simply omitted. To enable touchpad workspace-swipe later, use a `gesture`.

  binds = {
    workspace_back_and_forth = true,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
    focus_on_activate = true,
    on_focus_under_fullscreen = 1, -- replaces 0.53-removed new_window_takes_over_fullscreen
  },

  cursor = {
    hide_on_key_press = true,
  },
})

-- ── Animations (bezier curves + per-leaf, 0.53+ style) ─────────────────────
hl.config({ animations = { enabled = true } })
hl.curve("kiroEase", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "kiroEase" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })

-- ── Window rules (0.53+ unified hl.window_rule) ────────────────────────────
-- ArcoLinux windowrulev2 lines migrated to the table form.
hl.window_rule({ match = { class = "^(Spotify)$" }, tile = true })
-- Waybar "yay update" popup terminal:
hl.window_rule({ match = { class = "^(update)$", title = "^(update)$" }, float = true })
hl.window_rule({ match = { class = "^(update)$", title = "^(update)$" }, size = { "60%", "50%" } })
hl.window_rule({ match = { class = "^(update)$", title = "^(update)$" }, center = true })
-- Firefox picture-in-picture (kept handy, commented):
-- hl.window_rule({ match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" }, float = true })
-- Smooth touchpad scrolling in terminals (from nemesis input config):
hl.window_rule({ match = { class = "(Alacritty|kitty)" }, scroll_touchpad = 1.5 })
-- Transparent terminal — compositor opacity (works in VBox/QEMU/bare-metal alike; Hyprland's
-- blur frosts it). active/inactive: 0.90/0.85.
hl.window_rule({ match = { class = "Alacritty" }, opacity = "0.90 0.85" })
-- Lock the pointer inside an app — handy for games / remote desktop (0.55+):
-- hl.window_rule({ match = { class = "^(steam_app_.*)$" }, confine_pointer = true })

-- ── Autostart ──────────────────────────────────────────────────────────────
-- exec-once equivalent: run on the hyprland.start event.
local function on_start(cmd) hl.on("hyprland.start", function() hl.exec_cmd(cmd) end) end

on_start("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
on_start("dbus-update-activation-environment --systemd --all")
on_start("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
-- Create the XDG user dirs (Documents, Music, Pictures, …) on first login. This config doesn't
-- process /etc/xdg/autostart, so the xdg-user-dirs autostart never fires on its own. Idempotent.
on_start("xdg-user-dirs-update")
on_start("~/.config/hypr/scripts/import-gsettings.sh")   -- mirror GTK theme/icons/cursor/font into gsettings
on_start("swaybg -m fill -i ~/.config/hypr/bg/kiro.jpg")
on_start("waybar")
on_start("mako")
on_start("hypridle")
-- Live ISO only: auto-launch the installer. archiso-gated; kiro_final strips this line on install.
-- Wrapped in `sh -c` because hl.exec_cmd execs argv directly (no shell) — the `[ ]` test and `&&`
-- need a real shell to be interpreted; a bare string would just try to exec a binary named "[".
on_start("sh -c '[ -d /run/archiso/bootmnt ] && calamares_polkit -d -style kvantum'")
on_start("nm-applet --indicator")
on_start("variety")            -- wallpaper rotator (configured by kiro-variety-config)
-- on_start("pamac-manager")      -- software manager (pamac-aur)
-- on_start("blueman-applet")

-- ── Keybinds ───────────────────────────────────────────────────────────────
-- bindd-style: every bind carries a description (shown by the keybindings viewer).
local function bind(keys, desc, dispatcher, opts)
  opts = opts or {}
  if desc then opts.description = desc end
  hl.bind(keys, dispatcher, opts)
end
local function run(cmd) return hl.dsp.exec_cmd(cmd) end

-- Apps & session
bind(mod .. " + Return",         "Terminal",         run(term))
bind(mod .. " + T",              "Terminal",         run(term))
bind(mod .. " + SHIFT + Return", "File manager",     run(files))
bind(mod .. " + E",              "Code editor",      run(editor))
bind(mod .. " + D",              "Launch apps",      run(menu))
bind(mod .. " + SHIFT + D",      "Run launcher",     run("rofi -show run"))
bind(mod .. " + R",              "Theme selector",   run("rofi-theme-selector"))
bind(mod .. " + V",              "Volume control",   run("pavucontrol"))
bind(mod .. " + O",              "Colour picker",    run("hyprpicker -a"))
bind(mod .. " + Q",              "Close window",     hl.dsp.window.close())
bind(mod .. " + SHIFT + Q",      "Close window",     hl.dsp.window.close())
bind(mod .. " + X",              "Logout menu",      run(logout))
bind(mod .. " + SHIFT + E",      "Logout menu",      run(logout))
bind(mod .. " + SHIFT + X",      "Power menu",       run(powermenu))
bind(mod .. " + Escape",         "Kill mode",        run("hyprctl kill"))
bind(mod .. " + CTRL + S",       "Show keybindings", run(keybindings))
bind("CTRL + ALT + K",           "Lock screen",      run(lock))
bind(mod .. " + SHIFT + R",      "Reload Hyprland",  run("hyprctl reload"))

-- CTRL+ALT app launchers (Kiro scheme)
bind("CTRL + ALT + A",       "App finder",      run("xfce4-appfinder"))
bind("CTRL + ALT + B",       "File manager",    run(files))
bind("CTRL + ALT + C",       "File search",     run("catfish"))
bind("CTRL + ALT + E",       "Tweak tool",      run("archlinux-tweak-tool"))
bind("CTRL + ALT + F",       "Firefox",         run("firefox"))
bind("CTRL + ALT + G",       "Chromium",        run("chromium -no-default-browser-check"))
bind("CTRL + ALT + H",       "Tweak tool",      run("hyprland-tweak-tool"))
bind("CTRL + ALT + P",       "Package manager", run("pamac-manager"))
bind("CTRL + ALT + R",       "Theme selector",  run("rofi-theme-selector"))
bind("CTRL + ALT + Return",  "Terminal",        run(term))
bind("CTRL + ALT + T",       "Terminal",        run(term))
bind("CTRL + ALT + S",       "Tweak tool",      run("fish-tweak-tool"))
bind("CTRL + ALT + U",       "Volume control",  run("pavucontrol"))
bind("CTRL + ALT + V",       "Vivaldi",         run("vivaldi-stable"))
bind("CTRL + ALT + END",     "System monitor",  run("alacritty --class btop -e btop"))
bind("CTRL + SHIFT + Escape","System monitor",  run("alacritty --class btop -e btop"))

-- Function keys (Kiro scheme)
bind(mod .. " + F1",  "Firefox",      run("firefox"))
bind(mod .. " + F2",  "Code editor",  run("code"))
bind(mod .. " + F3",  "Inkscape",     run("inkscape"))
bind(mod .. " + F4",  "GIMP",         run("gimp"))
bind(mod .. " + F5",  "Meld",         run("meld"))
bind(mod .. " + F6",  "VLC",          run("vlc"))
bind(mod .. " + F7",  "VirtualBox",   run("virtualbox"))
bind(mod .. " + F8",  "File manager", run("thunar"))
bind(mod .. " + F9",  "Lollypop",     run("lollypop"))
bind(mod .. " + F10", "Spotify",      run("spotify"))
bind(mod .. " + F11", "Rofi drun",    run("rofi -show drun"))
bind(mod .. " + F12", "Rofi drun",    run("rofi -show drun"))

-- Window management
bind(mod .. " + SHIFT + Space", "Toggle floating", hl.dsp.window.float({ action = "toggle" }))
bind(mod .. " + F",             "Fullscreen",      hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind(mod .. " + ALT + F",       "Maximize",        hl.dsp.window.fullscreen({ mode = "maximized" }))
bind(mod .. " + P",             "Pseudo-tile",     hl.dsp.window.pseudo())
bind(mod .. " + J",             "Toggle split",    hl.dsp.layout("togglesplit"))
bind(mod .. " + G",             "Toggle group",    hl.dsp.group.toggle())

-- Master layout
bind(mod .. " + I",             "Add master",       hl.dsp.layout("addmaster"))
bind(mod .. " + CTRL + Return", "Swap with master", hl.dsp.layout("swapwithmaster"))

-- Groups — pull the focused window into the group in that direction, creating one if needed (0.55+)
bind(mod .. " + CTRL + left",  "Into group left",  hl.dsp.window.move({ into_or_create_group = "l" }))
bind(mod .. " + CTRL + right", "Into group right", hl.dsp.window.move({ into_or_create_group = "r" }))
bind(mod .. " + CTRL + up",    "Into group up",    hl.dsp.window.move({ into_or_create_group = "u" }))
bind(mod .. " + CTRL + down",  "Into group down",  hl.dsp.window.move({ into_or_create_group = "d" }))

-- Focus
bind(mod .. " + left",  "Focus left",  hl.dsp.focus({ direction = "l" }))
bind(mod .. " + right", "Focus right", hl.dsp.focus({ direction = "r" }))
bind(mod .. " + up",    "Focus up",    hl.dsp.focus({ direction = "u" }))
bind(mod .. " + down",  "Focus down",  hl.dsp.focus({ direction = "d" }))

-- Move / swap window
bind(mod .. " + SHIFT + left",  "Swap left",  hl.dsp.window.swap({ direction = "l" }))
bind(mod .. " + SHIFT + right", "Swap right", hl.dsp.window.swap({ direction = "r" }))
bind(mod .. " + SHIFT + up",    "Swap up",    hl.dsp.window.swap({ direction = "u" }))
bind(mod .. " + SHIFT + down",  "Swap down",  hl.dsp.window.swap({ direction = "d" }))

-- Resize
bind(mod .. " + SHIFT + H", "Shrink width",  hl.dsp.window.resize({ x = -50, y = 0,  relative = true }))
bind(mod .. " + SHIFT + L", "Grow width",    hl.dsp.window.resize({ x = 50,  y = 0,  relative = true }))
bind(mod .. " + SHIFT + K", "Shrink height", hl.dsp.window.resize({ x = 0,   y = -50, relative = true }))
bind(mod .. " + SHIFT + J", "Grow height",   hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }))

-- Mouse drag/resize
bind(mod .. " + mouse:272", "Move window",   hl.dsp.window.drag(),   { mouse = true })
bind(mod .. " + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })

-- Workspaces 1..10 — code: keys are layout-independent (qwerty AND azerty in ONE file).
for ws = 1, 10 do
  local key = "code:" .. tostring(ws + 9)            -- code:10 = "1" … code:19 = "0"
  bind(mod .. " + " .. key,         "Workspace " .. ws,         hl.dsp.focus({ workspace = tostring(ws) }))
  bind(mod .. " + CTRL + " .. key,  "Move to workspace " .. ws, hl.dsp.window.move({ workspace = tostring(ws) }))
  bind(mod .. " + SHIFT + " .. key, "Send to workspace " .. ws, hl.dsp.window.move({ workspace = tostring(ws), follow = false }))
end

-- Workspace cycling
bind(mod .. " + period",      "Next workspace",     hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + comma",       "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
bind(mod .. " + mouse_down",  "Next workspace",     hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + mouse_up",    "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
bind(mod .. " + TAB",         "Next workspace",     hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))

-- Scratchpad (special workspace)
bind(mod .. " + U",         "Toggle scratchpad",  hl.dsp.workspace.toggle_special("scratchpad"))
bind(mod .. " + SHIFT + U", "Send to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))

-- Media & brightness keys
bind("XF86AudioRaiseVolume",  "Volume up",      run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
bind("XF86AudioLowerVolume",  "Volume down",    run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
bind("XF86AudioMute",         "Mute",           run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
bind("XF86AudioPlay",         "Play / pause",   run("playerctl play-pause"))
bind("XF86AudioNext",         "Next track",     run("playerctl next"))
bind("XF86AudioPrev",         "Previous track", run("playerctl previous"))
bind("XF86MonBrightnessUp",   "Brightness up",  run("brightnessctl set 5%+"))
bind("XF86MonBrightnessDown", "Brightness down",run("brightnessctl set 5%-"))

-- Screenshots
bind("PRINT",           "Screenshot region", run('grim -g "$(slurp)" - | wl-copy'))
bind(mod .. " + PRINT", "Screenshot screen", run("grim - | wl-copy"))
