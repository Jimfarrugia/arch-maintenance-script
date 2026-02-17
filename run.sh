#!/usr/bin/env bash

script_dir="$(dirname "$(realpath "$0")")"
util_dir="$script_dir/utilities"

options=(
  "Check Arch Linux news"
  "Check for failed systemd services"
  "Check for errors in the log files"
  "Upgrade official packages"
  "Upgrade AUR packages"
  "Check for orphaned packages"
  "Clean packages cache"
  "Update mirror list"
  "Check disks health"
  "Reboot"
  "Quit"
)

# Make sure utilities are executable
chmod u+x -R "$util_dir"

# Print menu
echo
echo "Maintenance menu"
echo "Select an option:"

select choice in "${options[@]}"; do
  case $REPLY in
  1) exec "$util_dir/1-CheckArchNews" ;;
  2) exec "$util_dir/2-CheckFailedSystemd" ;;
  3) exec "$util_dir/3-CheckLogFiles" ;;
  4) exec "$util_dir/4-OfficialUpgrade" ;;
  5) exec "$util_dir/5-AURupgrade" ;;
  6) exec "$util_dir/6-OrphanedCheck" ;;
  7) exec "$util_dir/7-CleanPackagesCache" ;;
  8) exec "$util_dir/8-Mirrorlist" ;;
  9) exec "$util_dir/9-DisksCheck" ;;
  10) reboot ;;
  11 | 'q') exit ;;
  *) echo "Invalid option." ;;
  esac
done
