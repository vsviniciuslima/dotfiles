# Rebuild targetting a flake
_nix-rebuild() {
  local flake_dir="/home/viniciussl/dotfiles/nixos"
  
  # Check if the flake directory actually exists first
  if [ -d "$flake_dir" ]; then
    # -C tells git to run the command inside the target directory
    local untracked_files
    untracked_files=$(git -C "$flake_dir" status --porcelain 2>/dev/null | grep "^??" | sed 's/^?? //')

    if [[ -n "$untracked_files" ]]; then
      echo -e "\e[33m⚡ Found untracked files in Flake directory! Staging them now:\e[0m"
      
      echo "$untracked_files" | while read -r file; do
        echo -e "  \e[32m+ $file\e[0m"
      done
      
      # Explicitly run git add from the scope of your config directory
      git -C "$flake_dir" add -A
      echo ""
    fi
  fi

  echo "🚀 Rebuilding for $1 on desktop."
  sudo nixos-rebuild "$1" --flake "$flake_dir#desktop"
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
