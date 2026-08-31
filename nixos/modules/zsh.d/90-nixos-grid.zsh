# Rebuild targetting a flake
_nix-rebuild() {
  echo "Rebuilding for $1 on desktop."
  sudo nixos-rebuild "$1" --flake '/etc/nixos#desktop'
}

nix-switch() {
  _nix-rebuild "switch"
}

nix-test() {
  _nix-rebuild "test"
}

# Custom function to update system configurations and reset GNOME grids
nix-grid-update() {
  sudo nixos-rebuild switch && \
  dconf reset -f /org/gnome/shell/app-picker-layout && \
  dconf reset -f /org/gnome/desktop/app-folders/

  if [[ "$1" == "-l" || "$1" == "--logout" ]]; then
    echo "Rebuild successful! Logging out of GNOME..."
    gnome-session-quit --logout --no-prompt
  fi
}

# Function to dump your active live GNOME layout into clean Nix configurations
nix-grid-dump() {
  echo "Reading hot grid configurations from dconf..."
  local folders=$(dconf read /org/gnome/desktop/app-folders/folder-children)
  
  echo -e "\n=== COPY & PASTE THIS BLOCK INTO DCONF.SETTINGS ===\n"
  echo "        # Active folder configuration"
  echo "        \"org/gnome/desktop/app-folders\" = {"
  echo "          folder-children = ${folders//\'/\"};"
  echo "        };"

  if [[ -n "$folders" && "$folders" != "[]" ]]; then
    local clean_folders=$(echo "$folders" | tr -d "[]'" | tr "," " ")
    for folder in $clean_folders; do
      local apps=$(dconf read /org/gnome/desktop/app-folders/folders/$folder/apps)
      echo ""
      echo "        \"org/gnome/desktop/app-folders/folders/$folder\" = {"
      echo "          name = \"$folder\";"
      echo "          apps = ${apps//\'/\"};"
      echo "        };"
    done
  fi
  echo -e "\n===================================================\n"
}
