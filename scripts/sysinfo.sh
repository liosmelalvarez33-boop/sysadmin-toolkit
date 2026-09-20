#!/bin/bash
# sysinfo.sh — One-page Linux server health report.
# Usage: ./sysinfo.sh
set -euo pipefail

echo "🖥️  HOST: $(hostname) — $(date '+%F %T')"
echo "⏱️  UPTIME: $(uptime -p)"
echo ""
echo "💽 DISK:"
df -h / /home 2>/dev/null | awk 'NR==1 || $6=="/" || $6=="/home"'
echo ""
echo "🧠 MEMORY:"
free -h | awk 'NR==1 || NR==2'
echo ""
echo "🔥 TOP 5 PROCESSES (CPU):"
ps -eo comm,%cpu --sort=-%cpu | head -6
echo ""
echo "🔐 FAILED SSH LOGINS (today):"
grep "Failed password" /var/log/auth.log 2>/dev/null | grep "$(date '+%b %e')" | wc -l || echo "n/a (run with sudo)"
echo ""
echo "📦 UPDATES AVAILABLE:"
apt list --upgradable 2>/dev/null | grep -c upgradable || echo "n/a"
