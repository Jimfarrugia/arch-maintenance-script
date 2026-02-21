#!/usr/bin/env bash

script_dir="$(dirname "$(realpath "$0")")"
util_dir="$script_dir/utilities"

# --- Flags ---
# -q (quiet) to suppress dependency warnings and prompt
quiet=false
while getopts ":q" opt; do
  case "$opt" in
  q) quiet=true ;;
  *)
    echo "Usage: $0 [-q]"
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

# --- Dependency state ---
declare -A Dependencies=(
  ["yay"]=false
  ["curl"]=false
  ["xmlstarlet"]=false
  ["pacman-contrib"]=false
  ["reflector"]=false
  ["smartmontools"]=false
  ["gum"]=false
  ["ncdu"]=false
)

declare -A DepReason=(
  ["yay"]="required for updating AUR packages."
  ["curl"]="required for fetching Arch Linux news feed."
  ["xmlstarlet"]="required for parsing Arch Linux news feed."
  ["pacman-contrib"]="required for cleaning the packages cache."
  ["reflector"]="required for updating mirror list."
  ["smartmontools"]="required for checking disks health."
  ["gum"]="required for displaying packages select menu."
  ["ncdu"]="required for analyzing disk usage."
)

# --- Menu table ---
# Each entry: "Label|deps...|action"
# action types:
#   util:<file>     => exec "$util_dir/<file>"
#   shell:<command> => run a shell command (no exec)
#   exit            => exit 0
MENU_ITEMS=(
  "Check Arch Linux news|curl xmlstarlet|util:01-CheckArchNews"
  "Check for failed systemd services||util:02-CheckFailedSystemd"
  "Check for errors in the log files||util:03-CheckLogFiles"
  "Upgrade official packages||util:04-OfficialUpgrade"
  "Upgrade AUR packages|yay|util:05-AURupgrade"
  "Check for orphaned packages||util:06-OrphanedCheck"
  "Clean packages cache|pacman-contrib|util:07-CleanPackagesCache"
  "Clean temporary files||util:08-CleanTempFiles"
  "Clean log files||util:09-CleanLogFiles"
  "Update mirror list|reflector|util:10-Mirrorlist"
  "Update Betterfox|curl|util:11-Betterfox"
  "Check disks health|smartmontools|util:12-DisksCheck"
  "Add new packages to setup script|gum|util:13-UpdatePackageList"
  "Reboot||shell:reboot"
  "Quit||exit"
)

# --- Colors ---
RED=$'\e[31m'
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
DIM=$'\e[2m'
RESET=$'\e[0m'

# --- Helper: check deps list like "curl xmlstarlet" ---
check_dependencies() {
  local deps="$1"
  [[ -z "$deps" ]] && return 0

  local dep
  for dep in $deps; do
    if [[ "${Dependencies[$dep]}" != true ]]; then
      return 1
    fi
  done
  return 0
}

# --- Check for installed dependencies ---
for pkg in "${!Dependencies[@]}"; do
  if pacman -Q "$pkg" &>/dev/null; then
    Dependencies["$pkg"]=true
  fi
done

# --- Build warning + missing deps list
warning_message=""
missing_pacman_pkgs=()

for pkg in "${!Dependencies[@]}"; do
  if [[ "${Dependencies["$pkg"]}" != true ]]; then
    reason="${DepReason["$pkg"]}"
    warning_message+="- '$pkg' not installed: ${reason}\n"

    # Only add to pacman install list if it's not yay
    [[ "$pkg" == "yay" ]] || missing_pacman_pkgs+=("$pkg")
  fi
done

#--- Print warning + prompt to install ---
if [[ -n "$warning_message" ]] && ! $quiet; then
  echo -e "${YELLOW}WARNING:${RESET} Missing Dependencies"
  echo -e "$warning_message"

  # Prompt
  install_deps=false
  while true; do
    read -r -p "Install missing dependencies? [y/N]: " answer
    echo
    case "$answer" in
    [yY])
      install_deps=true
      break
      ;;
    [nN] | "")
      install_deps=false
      break
      ;;
    *) echo -e "${RED}Invalid option.${RESET}" ;;
    esac
  done

  if $install_deps; then
    # Tell them about yay (can't be installed via pacman)
    if [[ "${Dependencies["yay"]}" != true ]]; then
      echo -e "${RED}Warning:${RESET} 'yay' needs to be installed manually."
    fi

    # Install everything pacman can install
    if ((${#missing_pacman_pkgs[@]})); then
      sudo pacman -S --needed "${missing_pacman_pkgs[@]}" && exec "$script_dir/run.sh"
    else
      # Nothing pacman-installable missing; just restart to refresh dependency state
      exec "$script_dir/run.sh"
    fi
  fi
fi

# --- Build the displayed menu labels ---
menu_labels=()
menu_deps=()
menu_actions=()

for item in "${MENU_ITEMS[@]}"; do
  IFS='|' read -r label deps action <<<"$item"

  menu_deps+=("$deps")
  menu_actions+=("$action")

  if [[ -n "$deps" ]] && ! check_dependencies "$deps"; then
    # color only the label + show deps in dim text
    label="${RED}${label}${RESET} ${DIM}(missing: ${deps})${RESET}"
  fi

  menu_labels+=("$label")
done

echo
echo -e "${GREEN}Maintenance menu${RESET}"
echo -e "${YELLOW}Select an option:${RESET}"

select choice in "${menu_labels[@]}"; do
  idx=$((REPLY - 1))

  # validate selection
  [[ $idx -ge 0 && $idx -lt ${#menu_actions[@]} ]] || {
    echo -e "${RED}Invalid option.${RESET}"
    continue
  }

  deps="${menu_deps[$idx]}"
  action="${menu_actions[$idx]}"

  # block disabled items
  if [[ -n "$deps" ]] && ! check_dependencies "$deps"; then
    echo -e "${RED}Error:${RESET} missing required dependency/deps: $deps"
    continue
  fi

  case "$action" in
  util:*)
    util_file="${action#util:}"
    exec "$util_dir/$util_file"
    ;;
  shell:*)
    cmd="${action#shell:}"
    eval "$cmd"
    ;;
  exit)
    exit 0
    ;;
  *)
    echo "Unknown action: $action"
    ;;
  esac
done
