# kiro-hyprland — Claude project instructions

## Overview
Hyprland desktop config for the **KIROTUX Hyprland edition** (premium, private).

## Privacy — CRITICAL
- **Private. Never publish or push public.** Part of the KIROTUX monetization plan; kept
  hidden until sold. See the global memory `hyprland-monetize-private`.
- This edition is **separate from the free Kiro ISO** and **never goes into KIB** (the
  Kiro ISO Builder / public edition-block system). It is built standalone.

## Layout
- `etc/skel/.config/hypr/hyprland.lua` — the config (Lua format, Hyprland 0.55+).

## Build / test flow
- This repo is the **source of truth** for the config (the `etc/skel/.config/` tree). It is
  delivered as a **package**, not a skel-burn: `../KIROTUX-PKG-BUILD/kiro-hyprland/build.sh`
  packages this tree (`makepkg -f`, signs, `repo-add`) into `~/KIROTUX/kirotux-repo/`, and the
  ISO installs `kiro-hyprland` from the local `[kirotux-repo]`. The old skel-burn approach is
  gone — the ISO skel now carries only `.bashrc`.
- After editing the config here: rebuild the package (run the recipe above), then build the ISO
  via `kiro-iso-hyprland/build-scripts/build-the-iso.sh` to test a fresh install.
- `kiro-hyprland` is listed (commented as a template) inside the `### >>> EDITION-BLOCK hyprland`
  block in `packages.x86_64`; `apply_editions()` uncomments it at build time because
  `build.conf` sets `editions="hyprland"`.
- See [../CLAUDE.md](../CLAUDE.md) for the full KIROTUX delivery architecture and the relation
  to the other repos.

## Patterns / gotchas
- Native `hl.*` API only — do NOT use Omarchy's `o.*` helpers (those are Omarchy-private).
- Classic hyprlang `.conf` is deprecated (0.55) — stay on Lua.
- Two areas are inferred from Omarchy and unverified on real hardware: master-layout
  dispatchers (`hl.dsp.layout("addmaster"/"swapwithmaster")`) and window-rule effect keys
  (`tile`/`center`/`size`/`float`). Verify on a real boot.
