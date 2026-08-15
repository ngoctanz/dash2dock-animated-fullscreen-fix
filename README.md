# Dash2Dock Animated

> [!IMPORTANT]
> This is an unofficial compatibility-fix fork of
> [Dash2Dock Animated](https://github.com/icedman/dash2dock-lite), an original
> project by [icedman](https://github.com/icedman) and its contributors.
>
> This fork does not claim ownership of the original project and is not an
> official upstream release. It contains one focused compatibility fix for the
> hidden dock input region on newer GNOME/Wayland sessions.

## What problem does this fork fix?

With autohide enabled, the dock sometimes disappears visually but its previous
area still intercepts pointer input. Content behind that invisible area cannot
be clicked, selected, dragged, or scrolled. Disabling and re-enabling the
extension clears the problem temporarily, but it can return later.

This has been observed with Dash2Dock Animated v92 on GNOME 50/Wayland and is
especially noticeable when an application occupies the dock area.

## Why does it happen?

Dash2Dock Animated uses two separate GNOME Shell/Clutter actors:

- `dash` is the full-sized dock containing the icons.
- `DockDwell` is a tiny 2 px strip at the screen edge that detects the pointer
  and reveals the dock.

Autohide moves the `dash` outside the visible screen using translation. Moving
an actor visually does not automatically make it non-interactive: its
`reactive` and `track_hover` properties can remain enabled. On affected
GNOME/Wayland sessions, the hidden dash can therefore remain in Mutter's input
region and act like a transparent layer over the application.

Restarting the extension rebuilds its actors and input regions, which explains
why toggling the extension appears to fix the issue only temporarily.

## What is changed?

Only the full-sized `dash` hit area is changed in `autohide.js`:

```js
// When the dock starts showing
this.dock.dash.reactive = true;
this.dock.dash.track_hover = true;

// When the dock starts hiding
this.dock.dash.reactive = false;
this.dock.dash.track_hover = false;
```

The resulting behavior is:

1. While the dock is visible, its hit area is enabled and icons behave normally.
2. As soon as the dock starts hiding, its full-sized hit area is disabled, so
   pointer events reach the application behind it.
3. The existing edge trigger reveals the dock as before.
4. When the dock starts showing, its hit area is enabled again.

The patch does **not** change `DockDwell`, reveal conditions, pressure sensing,
fullscreen checks, animation timing, layout, appearance, or any theme option.
The original edge-to-reveal behavior is left untouched.

## Install this patched build

```bash
git clone https://github.com/ngoctanz/dash2dock-animated-fullscreen-fix.git
cd dash2dock-animated-fullscreen-fix
./install-local.sh
```

The installer creates a timestamped backup of the currently installed extension
before copying the patched runtime files. Log out and back in afterward; GNOME
Shell cannot be restarted with `Alt+F2`, `r` on Wayland.

An extension update may overwrite this patch. Reinstall this build or switch to
a newer upstream release when an equivalent fix becomes available there.

## Scope of the fork

The functional patch is intentionally limited to `AutoHide.show()` and
`AutoHide.hide()` in `autohide.js`. All other extension behavior remains from
the original Dash2Dock Animated v92 source.

The original project documentation continues below.

---

A GNOME Shell 40+ Extension

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/icedman)

![Contributors](https://img.shields.io/github/contributors/icedman/dash2dock-lite?color=dark-green) ![Forks](https://img.shields.io/github/forks/icedman/dash2dock-lite?style=social) ![Stargazers](https://img.shields.io/github/stars/icedman/dash2dock-lite?style=social) ![Issues](https://img.shields.io/github/issues/icedman/dash2dock-lite) ![License](https://img.shields.io/github/license/icedman/dash2dock-lite)

![Screen Shot](https://raw.githubusercontent.com/icedman/dash2dock-lite/main/screenshots/Screenshot%20from%202024-03-19%2015-31-27.png)

### Notice

* Supports GNOME 42, 43, 44, 45, 46, 47, 48, 49
* Initial support for GNOME 50
* Older versions are largely unsupported

### Features

* Multi-monitor support (new!)
* Dash docked at the desktop
* Animated dock icons
* Resize icons
* Autohide/intellihide
* Dock positions: bottom, top, left, right
* Scroll wheel to cycle windows
* Click to maximize/minimize windows
* Style top panel
* Panel mode
* Show/Hide Apps icon
* Analog clock
* Dynamic calendar
* Dynamic trash icon
* Mounted devices
* Downloads icon with fan animation (new!)
* Icon color effects (Tint, Monochrome)
* Custom icons

### Third-Party Compatibility

* [Compiz Magic Lamp Animation](https://github.com/PR3SIDENT/gnome-shell-extension-compiz-alike-magic-lamp-effect)
* [Blur my Shell](https://github.com/aunetx/blur-my-shell)

### Prerequisites

* GNOME Shell (version 42+)

### Upstream Installation

> The commands in this upstream section install the original project and do
> not include this fork's input-region fix. To install the fix, use
> [Install this patched build](#install-this-patched-build) above.

#### Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/icedman/dash2dock-lite.git
   ```
2. Build and install using the `Makefile`:
   ```bash
   cd dash2dock-lite
   make
   ```

#### Using the AUR (Arch User Repository)

*This requires an Arch-based distribution to work:*
```bash
git clone https://aur.archlinux.org/gnome-shell-extension-dash2dock-lite.git
cd gnome-shell-extension-dash2dock-lite
makepkg -si
```

#### From GNOME Extensions Repository

Visit [https://extensions.gnome.org/extension/4994/dash2dock-lite/](https://extensions.gnome.org/extension/4994/dash2dock-lite/)

## Theme Support

Export your settings under **Style** > **Themes Button** > **"Export"**...

This will be saved to `/tmp/theme.json`. Edit this JSON file and save it under `~/.config/d2da/themes` or at `{extension_path}/themes` so that it becomes available in the extension settings app.

## Custom Icons

Create a folder under `~/.config/d2da/icons` and place your SVG icons there. Then create a file under `~/.config/d2da/icons.json` using the following format:

```json
{
  "icons": {
     "view-app-grid-symbolic": "icons/show-apps-icon.svg",
     "user-trash": "icons/my-own-trash.svg",
     "user-trash-full": "icons/my-own-trash-full.svg"
  }
}
```

You may also use **icon names** from your favorite icon theme using the following format:

```json
{
  "icons": {
     "view-app-grid-symbolic": "show-apps-icon",
     "user-trash": "trash",
     "user-trash-full": "trash-full"
  }
}
```

The icons `show-apps-icon`, `trash`, and `trash-full` must be available in your icon theme folder.

Alternatively, you may override icons via app ID:

```json
{
   "apps": {
      "spotify_spotify": "icons/spotify.svg"
   }
}
```

Check the logs to see the icon names currently being used by Dash2Dock Animated. Search for log text such as:

```sh
Icon created "user-trash"
```

## Custom Config

Create a file `config.json` under the folder `~/.config/d2da/`

```json
{
  "file-explorer": "nemo",
  "icon-size": "24"
}
```

* Disable then enable the extension to load the configuration
* `file-explorer` overrides the default "nautilus"
* `icon-size` overrides the icon scale from the preferences panel

## Custom CSS

Create a file `style.css` under the folder `~/.config/d2da/`

For now, you will have to use Looking Glass (GNOME's built-in debugger) to inspect class names and styles.

## Blurred Background

The blurred background feature requires **ImageMagick** to be installed on the system. This generates the blurred image based on the desktop wallpaper.

## GNOME 42, 43, 44 Support

To build and install Dash2Dock Animated for older versions (prior to GNOME 45), run:

```bash
make g44
```

## Bug Reporting

When reporting bugs, please include the following details:

* Linux Flavor/Distribution and version
* GNOME version (e.g. 45.xx)
* Dash2Dock Animated release number

Check for any exceptions in the logs by running the following in the terminal:

```bash
journalctl /usr/bin/gnome-shell -f -o cat
```

To check for incompatibilities with other extensions, try running Dash2Dock Animated with all other extensions disabled.

To check for lag or inefficiency, run the following in the terminal and observe `gnome-shell` CPU usage:

```bash
top -d 0.5
```

On a Dell XPS 13 (i5-6200U), CPU usage is about 50% with icon quality set to High, frame rate set to High, and shadows enabled.

Please be specific about the errors encountered, and attach screenshots if possible.

## Testing Rig

* Fedora 43 (GNOME 49)
* Arch Linux (GNOME 49)
* Fedora 37 Live (GNOME 42)
* Ubuntu 23 (GNOME 45)

## License

Distributed under the GPL 3.0 License. See [LICENSE](LICENSE) for more information.
