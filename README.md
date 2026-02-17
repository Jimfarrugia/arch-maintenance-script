# Arch Maintenance Script

An all-in-one script that simplifies system maintenance on Arch Linux and Arch-based Linux distributions.

This script can :
1. Check the official Arch Linux news feed.
1. Check for failed systemd services.
3. Check for errors in the system log files.
4. Upgrade official packages.
5. Upgrade AUR packages.
6. Check for orphaned packages.
7. Clean packages cache.
8. Update the mirror list.
9. Check disks health.

## Usage

Clone this repo and execute `run.sh`.

Select which utility to run by entering a number when faced with the menu.

![Screenshot_2022-01-09_01-37-57](https://user-images.githubusercontent.com/84401519/148664681-52ff22e4-316f-4943-8853-d4191cd7eead.png)

## Dependencies

- `curl` and `xmlstarlet` for fetching Arch news.
- `yay` for updating AUR packages.
- `paccache` for cleaning the packages cache.
- `reflector` for updating mirror list.
- `smartmontools` for checking disk health.
- `ncdu` for analysing disk usage.
