# kiro-hyprland

The Hyprland desktop configuration for the **KIROTUX Hyprland edition** — a premium,
private edition built separately from the free Kiro ISO lineup.

> **Private — not for public release.** Part of the KIROTUX monetization plan; kept hidden
> until sold. Never publish or push to a public repo without Erik's explicit OK.

## What it ships

- `etc/skel/.config/hypr/hyprland.lua` — the Hyprland config, written in the modern **Lua
  config format** (Hyprland 0.55+; the classic `.conf`/hyprlang format is deprecated).

## How it's used

For testing, the config is **burned directly into the ISO** (`kiro-iso-hyprland`) under
`archiso/airootfs/etc/skel/.config/hypr/` — no package, no `nemesis_repo`, no repo needed.
New user accounts created on the live/installed system inherit it from `/etc/skel`.

## Notes

- Targets Hyprland **0.55+**. Two values in the config (master-layout dispatchers and a few
  window-rule effect keys) are modeled on Omarchy's shipping config and should be verified
  on a real boot.
- Number-row workspace binds use `code:` keycodes, so the single file works for both QWERTY
  and AZERTY without separate variants.
