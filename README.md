# 🧰 sysadmin-toolkit

Production-ready bash scripts for everyday Linux server administration. Written to be **safe, idempotent, and readable** — the same scripts I use on client servers.

## 📜 Scripts

| Script | What it does |
|---|---|
| `scripts/server-setup.sh` | First-boot VPS setup: updates, firewall (UFW), fail2ban, SSH hardening, unattended upgrades |
| `scripts/backup-auto.sh` | Compressed rotating backups of any directory (keeps N newest) |
| `scripts/sysinfo.sh` | One-page server health report: uptime, disk, RAM, top processes, failed logins |

## 🚀 Usage

```bash
git clone https://github.com/liosmelalvarez33-boop/sysadmin-toolkit.git
cd sysadmin-toolkit/scripts
chmod +x *.sh

# New VPS? Harden it in one command (Debian/Ubuntu):
sudo ./server-setup.sh

# Back up /var/www, keep the 7 newest, store in /backups:
sudo ./backup-auto.sh /var/www /backups 7

# Health check:
./sysinfo.sh
```

## ⚠️ Notes

- `server-setup.sh` **disables SSH password login** — make sure your SSH key is installed before running it on a remote server.
- All scripts are idempotent: safe to run twice.
- Tested on Debian 12/13 and Ubuntu 22.04/24.04.

---

*Part of my freelance toolkit — I offer server setup & automation as a service, paid in USDT. See my [profile](https://github.com/liosmelalvarez33-boop).*
