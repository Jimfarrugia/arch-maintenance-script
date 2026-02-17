#!/bin/bash

chmod u+x -R $(dirname $(realpath $0))/utilities/

# Menu

echo -e "\n"
echo "Maintenance menu"
echo "Select an option :"

select MenuChoice in \
  "Check for failed systemd services" \
  "Check for errors in the log files" \
  "Upgrade official packages" \
  "Upgrade AUR packages" \
  "Check for orphaned packages" \
  "Clean packages cache" \
  "Update mirror list" \
  "Check disks health" \
  "Reboot computer" \
  "Exit program"; do
  case $MenuChoice in

  # Systemd services check

  "Check for failed systemd services") exec $(dirname $(realpath $0))/utilities/1-CheckFailedSystemd ;;

  # Error check

  "Check for errors in the log files") exec $(dirname $(realpath $0))/utilities/2-CheckLogFiles ;;

  # Official packages upgrade

  "Upgrade official packages") exec $(dirname $(realpath $0))/utilities/3-OfficialUpgrade ;;

  # AUR packages upgrade

  "Upgrade AUR packages") exec $(dirname $(realpath $0))/utilities/4-AURupgrade ;;

  # Orphaned packages check

  "Check for orphaned packages") exec $(dirname $(realpath $0))/utilities/5-OrphanedCheck ;;

  # Packages cache cleaning

  "Clean packages cache") exec $(dirname $(realpath $0))/utilities/6-CleanPackagesCache ;;

  # Update mirror list

  "Update mirror list") exec $(dirname $(realpath $0))/utilities/7-Mirrorlist ;;

  # Disks health checking

  "Check disks health") exec $(dirname $(realpath $0))/utilities/8-DisksCheck ;;

  # Reboot computer

  "Reboot computer") reboot ;;

  # Exit

  "Exit program") exit ;;

  esac
done
