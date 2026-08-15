#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
extension_root="${XDG_DATA_HOME:-$HOME/.local/share}/gnome-shell/extensions"
target_dir="$extension_root/dash2dock-lite@icedman.github.com"

mkdir -p -- "$extension_root"

if [[ -d "$target_dir" ]]; then
  backup_dir="${target_dir}.backup-$(date +%Y%m%d-%H%M%S)"
  cp -a -- "$target_dir" "$backup_dir"
  printf 'Backup created: %s\n' "$backup_dir"
fi

mkdir -p -- "$target_dir"
cp -a -- \
  "$repo_dir"/*.js \
  "$repo_dir/metadata.json" \
  "$repo_dir/stylesheet.css" \
  "$repo_dir/apps" \
  "$repo_dir/effects" \
  "$repo_dir/preferences" \
  "$repo_dir/schemas" \
  "$repo_dir/ui" \
  "$target_dir"/

printf '%s\n' 'Installed patched Dash2Dock Animated.'
printf '%s\n' 'Log out and back in to reload GNOME Shell on Wayland.'
