#!/bin/bash
# server-setup.sh — First-boot setup & hardening for Debian/Ubuntu VPS.
# Usage: sudo ./server-setup.sh
# WARNING: disables SSH password auth. Install your SSH key BEFORE running remotely.
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "❌ Run as root (sudo ./server-setup.sh)"; exit 1
fi

echo "📦 [1/5] Updating system..."
apt-get update -qq && apt-get upgrade -y -qq

echo "🔥 [2/5] Configuring firewall (UFW: SSH + HTTP/HTTPS)..."
apt-get install -y -qq ufw fail2ban unattended-upgrades
ufw --force reset >/dev/null
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw --force enable

echo "🛡️  [3/5] Hardening SSH..."
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak.$(date +%F)
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config
systemctl restart ssh

echo "🤖 [4/5] Enabling automatic security updates..."
systemctl enable --now unattended-upgrades

echo "🚫 [5/5] Enabling fail2ban..."
systemctl enable --now fail2ban

echo ""
echo "✅ Server hardened. Quick status:"
ufw status | head -8
echo ""
echo "⚠️  SSH password login is now DISABLED. Key-only access."
