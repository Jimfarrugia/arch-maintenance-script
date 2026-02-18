Wiki Reference:

https://wiki.archlinux.org/title/System_maintenance

---

Scan root dir with ncdu

- Offer to analyse disk usage with `ncdu`. (`ncdu / --exclude /mnt --exclude /media`)

---

In utility 8, list disks with `lsblk` before asking which disk to test/check.

Also fix it so it can work for nvme volumes.

---

- Check git repos for un-synced changes
