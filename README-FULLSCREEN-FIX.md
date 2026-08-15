# Dash2Dock Animated hidden input-region fix

This repository is an unofficial patched copy of version 92 of
[Dash2Dock Animated](https://github.com/icedman/dash2dock-lite), an original
project by [icedman](https://github.com/icedman). All original project credit
belongs to its author and contributors. This fork only provides a compatibility
fix for newer GNOME releases and is not an official upstream release.

## The bug

With autohide enabled on GNOME 50/Wayland, the dock can disappear visually while
its full-sized input actor continues consuming pointer events over application
content. Disabling and enabling the extension clears the stale input region only
temporarily.

## The fix

The patch changes only the hidden dash hit area:

- The full-sized dash hit area becomes non-reactive as soon as the dock starts
  hiding and becomes reactive again when it starts showing. This prevents the
  invisible dock area from consuming application input on Wayland.
- The separate edge-dwell actor, fullscreen checks, reveal conditions, timing,
  and animations are not changed.

No actor is destroyed, so autohide animation and edge activation continue to
behave as configured by the original extension.

## Install for the current user

```bash
./install-local.sh
```

The installer first creates a timestamped backup beside the installed extension,
then copies only runtime files (never `.git`). Log out and back in afterward.
GNOME on Wayland cannot reload the Shell with `Alt+F2`, `r`.

Extension updates may overwrite the patch. Reapply it or install a newer
upstream release once the issue is fixed there.

## Restore the original extension

Remove and reinstall Dash2Dock Animated from the Extensions application, or
replace the extension directory with the timestamped backup created by the
installer.
