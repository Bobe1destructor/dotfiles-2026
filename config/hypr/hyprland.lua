-- Hyprland 0.57+ Lua configuration
-- Preserves the original dotfiles look, shortcuts and laptop workflow.

local home = os.getenv("HOME") or ""
local colors_path = home .. "/.cache/wal/colors-hyprland.lua"
local ok_colors, colors = pcall(dofile, colors_path)
if not ok_colors or type(colors) ~= "table" then
    colors = {
        color0 = "#1a1b26", color1 = "#f7768e", color2 = "#9ece6a",
        color3 = "#e0af68", color4 = "#7aa2f7", color5 = "#ad8ee6",
        color6 = "#449dab", color7 = "#a9b1d6", color8 = "#444b6a",
        color9 = "#ff7a93", color10 = "#b9f27c", color11 = "#ff9e64",
        color12 = "#7da6ff", color13 = "#bb9af7", color14 = "#0db9d7",
        color15 = "#acb0d0",
    }
end

local function hypr_color(value)
    return "rgb(" .. tostring(value):gsub("#", "") .. ")"
end

local terminal = "kitty"
local file_manager = "dolphin"
local menu = "wofi --show drun"
local browser = "firefox"
local main_mod = "SUPER"

-- Display: use the preferred native mode and preserve the original 1.6 scale.
-- The fallback rule also handles external monitors without hardcoding their names.
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1.6,
})

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOW_DECORATION", "1")
hl.env("GDK_SCALE", "1")
hl.env("GDK_BACKEND", "wayland")
hl.env("XDG_MENU_PREFIX", "arch-")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 3,
        col = {
            active_border = {
                colors = { hypr_color(colors.color3), hypr_color(colors.color6) },
                angle = 45,
            },
            inactive_border = hypr_color(colors.color0),
        },
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 50,
            render_power = 9,
            color = "rgba(00000099)",
        },
        blur = {
            enabled = false,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    dwindle = {
        pseudotile = true,
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
    input = {
        kb_layout = "latam",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = true,
        },
    },
    xwayland = {
        force_zero_scaling = true,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- Original animation timings and curves.
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Main application shortcuts.
hl.bind(main_mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(main_mod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(main_mod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(main_mod .. " + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + UP", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + DOWN", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(main_mod .. " + MOUSE_DOWN", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + MOUSE_UP", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media, volume and brightness keys.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshot shortcuts. Output directory is created by the installer.
local shots = home .. "/Pictures/Screenshots"
hl.bind("PRINT", hl.dsp.exec_cmd("grim '" .. shots .. "/$(date +'%Y-%m-%d_%H-%M-%S').png' && notify-send 'Captura' 'Pantalla completa guardada'"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("grim -g \"$(slurp)\" '" .. shots .. "/$(date +'%Y-%m-%d_%H-%M-%S').png' && notify-send 'Captura' 'Región guardada'"))
hl.bind("ALT + PRINT", hl.dsp.exec_cmd("grim -g \"$(hyprctl -j activewindow | jq -r '\''\"\\(.at[0]),\\(.at[1]) \\( .size[0])x\\(.size[1])\"'\'')\" '" .. shots .. "/$(date +'%Y-%m-%d_%H-%M-%S').png'"))
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("grim - | wl-copy && notify-send 'Captura' 'Pantalla copiada'"))
hl.bind("CTRL + SHIFT + PRINT", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy && notify-send 'Captura' 'Región copiada'"))

-- Start desktop services only after the compositor is ready.
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("sh -c 'command -v swww-daemon >/dev/null 2>&1 && swww-daemon'")
end)
