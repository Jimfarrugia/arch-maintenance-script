Wiki Reference:

https://wiki.archlinux.org/title/System_maintenance


---

check for new packages not included in setup script
- List explicitly-installed packages that are not found in 'pkg_list' (from A.S.S.)
    - offer to selectively uninstall or add them to (pkg_list)

A.S.S is a dependency for this util

---

Scan root dir with ncdu

- Offer to analyse disk usage with `ncdu`. (`ncdu / --exclude /mnt --exclude /media`)

---

In utility 8, list disks with `lsblk` before asking which disk to test/check.

Also fix it so it can work for nvme volumes.

---

- Check git repos for un-synced changes
