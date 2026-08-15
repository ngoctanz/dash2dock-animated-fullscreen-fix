# Dash2Dock Animated fullscreen input fix

This repository is an unofficial patched copy of version 92 of
[Dash2Dock Animated](https://github.com/icedman/dash2dock-lite), an original
project by [icedman](https://github.com/icedman). All original project credit
belongs to its author and contributors. This fork only provides a compatibility
fix for newer GNOME releases and is not an official upstream release.

## The bug

With autohide enabled on GNOME 50/Wayland, the dock can visually hide behind a
fullscreen application while its transparent input actors continue consuming
pointer events near the dock edge. Disabling and enabling the extension clears
the stale input region only temporarily.

## The fix

The patch separates the two input responsibilities:

- The tiny 2 px edge-dwell actor remains interactive while the dock is hidden,
  including over fullscreen windows, so moving the pointer to the screen edge
  can still reveal the dock.
- The full-sized dash hit area becomes non-reactive as soon as the dock starts
  hiding and becomes reactive again when it starts showing. This prevents the
  invisible dock area from consuming application input on Wayland.

No actor is destroyed, so autohide animation and edge activation continue to
work both normally and over fullscreen applications.

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
