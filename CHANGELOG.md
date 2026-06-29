# Changelog

## 2026.06.29

### What Changed
- **Aligned the Hyprland keybindings to the ohmychadwm reference and rebuilt the cheat sheet.**
  The `keybindings.txt` viewer (shown by `SUPER + CTRL + S`) was missing the entire CTRL+ALT
  app-launcher block and the `SUPER + F2..F12` app keys — "all the Kiro apps" were absent. It
  now mirrors `hyprland.lua` in full.
- **New CTRL+ALT app launchers** ported from ohmychadwm's `sxhkdrc`/`keybindings.txt`:
  `A`/`Q` → alacritty-tweak-tool, `D` → obs, `I` → kiro-iso-builder,
  `L` → `archlinux-logout --settings`, `M` → `mintstick -m iso`, `O` → opera,
  `W`/`Z` → fastfetch-tweak-tool. Plus `SUPER + Space` → app launcher and
  `ALT + R` → theme selector.
- **Aligned divergent binds to the reference:** `CTRL + ALT + A` → alacritty-tweak-tool (was
  xfce4-appfinder), `CTRL + ALT + R` → archlinux-betterlockscreen (was theme selector),
  `CTRL + ALT + B` → brave (was thunar), `CTRL + ALT + C` → chromium (was catfish),
  `CTRL + ALT + K` → archlinux-logout (was hyprlock), `SUPER + F9` → virt-manager (was
  lollypop). `SUPER + F1` deliberately kept on firefox (reference uses vivaldi).
- **Deliberately dropped** the reference's `update-system` binds (not used in KIROTUX).
- **Regenerated `keybindings.txt` via `/kiro-create-keybindings`** into the standard fixed
  8-section Kiro layout (header + `── N. Title ──` sections), replacing the earlier
  hand-authored box-drawing format, and emitted the matching `keybindings.html` +
  `keybindings.pdf` cheat sheets via `~/.bin/kiro-keybindings-html.py`.
- **Removed `SUPER + SHIFT + E`** (was a duplicate logout-menu chord; `SUPER + X` and
  `CTRL + ALT + K` already cover logout) from both `hyprland.lua` and the regenerated viewer.

### Technical Details
- Both `etc/skel/.config/hypr/hyprland.lua` and the sibling `keybindings.txt` were updated
  together so the viewer never drifts from the live binds. A duplicate-key scan confirms no
  two binds share a chord.
- **Known gap (RESOLVED later same day, see next section):** `CTRL + ALT + K` moving to logout
  left `hyprlock` unbound. The fix routes locking through `archlinux-logout` (its Lock button
  now resolves to `hyprlock` on Wayland) and adds `hyprlock.conf`. `CTRL + ALT + R` is the
  betterlockscreen wallpaper picker (a GTK4 app that *does* run on Wayland — it only generates
  the blur cache), not a locker; its label was corrected. The `local lock = "hyprlock"` variable
  remains unused — kept in case a direct one-key lock chord is wanted later.
- `--settings` is undocumented in `archlinux-logout --help-all` but verified working on the
  live app (opens "ArchLinux Logout Settings").

### Files Modified
- `etc/skel/.config/hypr/hyprland.lua`
- `etc/skel/.config/hypr/keybindings.txt`
- `etc/skel/.config/hypr/keybindings.html` (generated)
- `etc/skel/.config/hypr/keybindings.pdf` (generated)

### Wayland lock screen — hyprlock wired to the betterlockscreen wallpaper

**What Changed.** Added `etc/skel/.config/hypr/hyprlock.conf` so the Hyprland lock screen shows
the wallpaper the user picks in `archlinux-betterlockscreen`, and corrected two mislabeled
"Lock screen" entries. This resolves the "no working Wayland lock binding" gap noted above.

**Technical Details.**
- `hyprlock.conf` background `path = $HOME/.cache/betterlockscreen/current/lock_dimblur.png` —
  the dim+blur image `betterlockscreen -u` caches (closest match to the old `betterlockscreen -l
  dim` look). hyprlock does not expand `~`, hence `$HOME`. If the cache is absent the block
  falls back to a solid dark color, so the screen still locks. Clock/date/greeting/password
  styled in JetBrainsMono Nerd Font to match the rice.
- The lock is driven by `archlinux-logout` (`CTRL + ALT + K`), whose Lock button now resolves to
  `hyprlock` on Wayland (see archlinux-logout-gtk4 CHANGELOG, same date).
- Relabeled `CTRL + ALT + R` from "Lock screen" to "Lockscreen wallpaper" in both
  `hyprland.lua` and `keybindings.txt` — it opens the betterlockscreen picker, it does not lock.
- `hyprlock` is already a declared PKGBUILD dependency; no dependency change needed.

**Files Modified.**
- `etc/skel/.config/hypr/hyprlock.conf` (new)
- `etc/skel/.config/hypr/hyprland.lua`
- `etc/skel/.config/hypr/keybindings.txt`

## 2026.06.28

### What Changed
- **Ship Kiro's fastfetch config in the skel.** Added `etc/skel/.config/fastfetch/`
  (`config.jsonc` + `kiro-color-24.txt`, sourced from `kiro-dot-files`). The Hyprland edition
  previously had no fastfetch config — a fresh install showed default fastfetch, and it was
  missing from `hyprland-tweak-tool`'s "Restore Kiro Hyprland" (which restores the configs in
  `/etc/skel/.config`). Now fastfetch is part of the Kiro Hyprland config set on install and is
  restorable. **Rebuild `kiro-hyprland`.**
- **`CTRL + ALT + H` launches `hyprland-tweak-tool`.** Added to the alphabetical CTRL+ALT
  app-launcher block in `hyprland.lua` (between G/Chromium and P/Package manager), mirroring
  the existing `CTRL + ALT + E` → `archlinux-tweak-tool` shortcut.
- **`CTRL + ALT + S` now launches `fish-tweak-tool`** (was Spotify). Repurposed the S slot
  in the same launcher block.
- **Ship a pristine golden copy of the config at `/usr/share/kiro/hyprland/`** (PKGBUILD
  pkgrel 8 → 9). In addition to `/etc/skel`, the package now installs a read-only copy of
  the whole desktop config (hypr/, waybar/, mako/, gtk-3.0/, gtk-4.0/) to a stable system
  path. This is the source `hyprland-tweak-tool` uses for its **"Restore Kiro Hyprland"**
  action — it removes the user's config dirs and rewrites these, clearing leftovers from a
  community setup (e.g. a foreign waybar).

### Technical Details
- `package()` in `KIROTUX-PKG-BUILD/kiro-hyprland/PKGBUILD` adds
  `install -dm755 "${pkgdir}/usr/share/kiro/hyprland"` +
  `cp -a "${srcdir}/etc/skel/.config/." "${pkgdir}/usr/share/kiro/hyprland/"`. Single
  source (the skel tree) duplicated at package time — no duplicate files in the repo.

### Files Modified
- `KIROTUX-PKG-BUILD/kiro-hyprland/PKGBUILD`

## 2026.06.24

### What Changed
- **Auto-create the XDG user directories on first login.** Added `on_start("xdg-user-dirs-update")`
  to the autostart section of `hyprland.lua`. On a fresh install only `Downloads`/`DATA` existed in
  `$HOME` because nothing ever generated `~/.config/user-dirs.dirs`, so `Documents`, `Music`,
  `Pictures`, `Videos`, `Desktop`, `Templates`, `Public` (and Nemesis's `Projects`) never appeared.

### Technical Details
- Root cause: this Lua config does not process `/etc/xdg/autostart/` `.desktop` files (there is no
  `dex`/`dapper` in autostart), so the stock `xdg-user-dirs` autostart entry never fired. The fix is
  an explicit `on_start` call. `xdg-user-dirs-update` is a bare binary (no shell wrapper needed),
  takes no args, and is idempotent — safe to run every session. Folders are generated from
  `/etc/xdg/user-dirs.defaults` (which the Nemesis base extends with `PROJECTS=Projects`).
- Verified on real metal (picard): the line was also inserted into picard's already-installed
  config and `xdg-user-dirs-update` run by hand — all nine folders plus `user-dirs.dirs` appeared.

### Files Modified
- `etc/skel/.config/hypr/hyprland.lua`

## 2026.06.23

### What Changed
- Created `kiro-hyprland` — the Hyprland desktop config for the private KIROTUX Hyprland
  edition. Holds a modern Lua-format `hyprland.lua` baseline.
- **Adopted low-risk Hyprland 0.55 features** in `hyprland.lua`: a subtle inner **glow** on the
  focused window, **group-aware move binds** (`mod+CTRL+arrows`), and a commented `confine_pointer`
  window-rule example. Deployed to the VM and verified (`hyprctl configerrors` clean, glow active).

### Technical Details
- Config written in the **Lua config format** (Hyprland 0.55+; classic hyprlang `.conf` is
  deprecated as of 0.55). Modeled on Omarchy's current Lua config (native `hl.*` API only,
  no Omarchy `o.*` helper layer) but carrying Kiro/ArcoLinux's SUPER-based keybinds.
- Migrated away from the stale ArcoLinux baseline: unified `hl.window_rule` (0.53 rewrite),
  `layoutmsg`-based togglesplit (0.54 removal), dropped `dwindle:pseudotile` (0.55 removal),
  `on_focus_under_fullscreen` rename.
- Number-row workspaces use `code:` keycodes (layout-independent → one file for QWERTY+AZERTY).
- **0.55 feature keys** (verified against the Hyprland source / `hl.meta.lua` stubs, not guessed):
  `decoration:glow:{enabled,range,render_power,color,color_inactive}` (glow set to the Kiro blue
  accent `rgba(7aa2f7cc)`, `color_inactive` transparent so it shows only on the focused window);
  group move is **not** a standalone dispatcher — it's `hl.dsp.window.move({ into_or_create_group = "l/r/u/d" })`;
  `confine_pointer` is a window-rule bool. The pinch cursor-zoom gesture (`hl.gesture` with
  `action = "cursor_zoom"`) is deferred — the valid pinch `direction` string lives in the
  TrackpadGestures manager (not the stubs) and it's untestable in a VM (no trackpad).
- Burned into `kiro-iso-hyprland/archiso/airootfs/etc/skel/.config/hypr/` for testing — no
  package/repo.
- Tweaked to match the repo-only ISO package set (no AUR): screenshots via `grim`+`slurp`+`wl-copy`
  (dropped `grimblast`), added `mako` to autostart (notification daemon).
- **Grew into the full Hyprland rice** (replacing the dropped `kiro-dot-files` for this edition):
  added `waybar/{config.jsonc,style.css}`, `mako/config`, a Kiro-scheme `hypr/keybindings.txt`,
  and the bundled wallpaper `hypr/bg/kiro.jpg` (the wallhaven minimal mountains Erik chose).
  Waybar/mako/style are clean self-contained configs in Kiro's tokyo-night palette (no Omarchy
  custom modules), font = JetBrainsMono Nerd Font.
- **Keybinds aligned to the Kiro scheme** (sourced from `kiro-i3`): logout via `archlinux-logout`
  (`SUPER+X`, `SUPER+Shift+E`), power menu `SUPER+Shift+X` (`kiro-powermenu`), show-keybindings
  `SUPER+Ctrl+S`. Wallpaper path switched to `kiro.jpg`.
- **PKGBUILD now ships the whole `etc/skel` tree** (was hypr-only) and depends on
  `hyprland waybar mako swaybg`.
- **First-boot fix:** removed the `gestures { workspace_swipe }` block — those keys were
  removed in Hyprland 0.51 (replaced by the configurable `gesture` syntax) and threw a
  config-error overlay on the live ISO. Swipe was disabled anyway, so omitting it is a no-op.
  Everything else in the config validated cleanly on first boot.
- **Ported live VM tweaks back to source** (tested over SSH in the Hyprland VM, then captured):
  cursor size `24`→`12` (XCURSOR/HYPRCURSOR), decoration `rounding` `10`→`5`.
- **VM compatibility env vars** added (`WLR_NO_HARDWARE_CURSORS=1`, `WLR_RENDERER_ALLOW_SOFTWARE=1`)
  — per the Hyprland wiki VM section, these are required so VirtualBox "3D acceleration" doesn't
  black-screen; harmless on real hardware.
- **Translated Erik's nemesis hypr-omarchy settings into the Lua config**
  (`~/DATA/arcolinux-nemesis/personal/settings/hypr-omarchy/`, registered as the top reference):
  - input: `kb_layout = "be,us"`, `kb_options = "compose:caps"`, `repeat_rate=40`, `repeat_delay=600`.
  - terminal touchpad scroll: `hl.window_rule({ match={class="(Alacritty|kitty)"}, scroll_touchpad=1.5 })`.
  - full **`bindd`-style described keybind set** (every bind has a description for the keybindings
    viewer): CTRL+ALT app launchers, F1–F12, logout/power. Adapted `walker`→`rofi`,
    `edu-powermenu`→`kiro-powermenu`, `$files`→`thunar`; **dropped the variety wallpaper binds**
    (we use `swaybg`, and they referenced a non-existent statusbar script).
  - Validated on the live VM: `hyprctl configerrors` empty, 115 binds loaded, `kb_layout=be,us`.
- **Monitors & scaling block** added (Lua equivalent of Omarchy's `monitors.conf`):
  `hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })` + `GDK_SCALE=1`,
  with commented HiDPI variants (2× retina, 1.6/1.75 4K, transform for rotated). The Lua monitor
  API is `hl.monitor(spec)` (HL.MonitorSpec: output/mode/position/scale/transform/…). Validated
  on the VM (configerrors empty, scale 1.00).
- **Calamares auto-launch: added, then removed from `hyprland.lua`.** It worked (launched via
  `calamares_polkit` on the live boot, archiso-gated) but `hyprland.lua` ships in `/etc/skel`, so the
  line lands in the *installed* user's config too — an installed system shouldn't carry an
  installer-launch line. The live-only auto-launch belongs in a live-only mechanism (ISO airootfs /
  calamares-config), not the desktop config — TODO. For now the user launches the installer from its
  desktop icon (`cal-kiro.desktop`).
- **Calamares auto-launch re-added AND fixed (root cause: `hl.exec_cmd` has no shell).** The line was
  back in the config as `on_start("[ -d /run/archiso/bootmnt ] && calamares_polkit")` but Calamares
  never launched on the live VM. Diagnosed over SSH: every *other* `on_start` line ran (waybar, mako,
  swaybg, hypridle all up) — only this one failed, because it is the only line using shell syntax.
  `hl.exec_cmd` execs argv directly (it does tilde-expansion itself, but does **not** run through
  `/bin/sh`), so the `[ ]` test and `&&` are meaningless to it — it just tries to exec a binary named
  `[`. (The old hyprlang `exec-once` used `sh -c`, which is why the same line "worked before" the Lua
  port.) Fix: wrap in an explicit shell and carry the same args as the `cal-kiro.desktop` launcher —
  `on_start("sh -c '[ -d /run/archiso/bootmnt ] && calamares_polkit -d -style kvantum'")`. The
  `-style kvantum` keeps the Kiro Kvantum theme (bare `calamares_polkit` launches with the default Qt
  style); only the desktop `%f` field code is dropped (no file arg in autostart). `hl.exec_cmd` honors
  quotes, so the `sh -c '...'` arg stays one token. Verified end-to-end on the live VM:
  `calamares_polkit -d -style kvantum` → `/usr/bin/calamares -d -style kvantum` (args propagate through
  the wrapper's `"$@"`). Stays one line containing `calamares_polkit`, so `kiro_final`'s
  `sed -e /calamares_polkit/d` strip still removes it on install.
- **Autostart additions:** `nm-applet --indicator` (NetworkManager tray, uncommented), plus `variety`
  (wallpaper rotator, configured by `kiro-variety-config`) and `pamac-manager` (software manager,
  `pamac-aur`). All three packages already ship in the Hyprland ISO `packages.x86_64`. Note: `variety`
  overlaps the existing `swaybg` wallpaper line, and `pamac-manager` autostarts on every login
  (including installed systems) — candidates for archiso-gating if that's not wanted.
- **Transparent terminal.** `hl.window_rule({ match = { class = "Alacritty" }, opacity = "0.90 0.85" })`
  — compositor-level opacity, so it works identically in VBox/QEMU/bare-metal (no X11 compositor:
  Hyprland is its own Wayland compositor — `picom`/`fastcompmgr` are X11-only and not used). Hyprland's
  native `decoration.blur` frosts it.
- **GTK theming (closes the polish gap).** Added `gtk-3.0/settings.ini` + `gtk-4.0/settings.ini`
  with Kiro's defaults (Arc-Dark, neo-candy-icons, Bibata-Modern-Ice cursor, Noto Sans 11,
  prefer-dark) + `XCURSOR_THEME=Bibata-Modern-Ice`, and `hypr/scripts/import-gsettings.sh`
  (Erik's `gsettings.sh`) autostarted to mirror those `.ini` values into `org.gnome.desktop.interface`
  gsettings (Wayland has no xsettings daemon; GTK4/libadwaita read gsettings). Validated on the VM:
  import ran, all five keys set correctly, configerrors empty.

### Files Modified
- `etc/skel/.config/hypr/hyprland.lua`, `hypr/keybindings.txt`, `hypr/bg/kiro.jpg`
- `etc/skel/.config/waybar/config.jsonc`, `waybar/style.css`, `mako/config`
- `README.md`, `CHANGELOG.md`, `CLAUDE.md`
