#!/bin/bash
# backup-auto.sh — Compressed rotating backups.
# Usage: sudo ./backup-auto.sh <source_dir> <dest_dir> [keep]
# Example: sudo ./backup-auto.sh /var/www /backups 7
set -euo pipefail

SRC="${1:?Usage: $0 <source_dir> <dest_dir> [keep]}"
DEST="${2:?Usage: $0 <source_dir> <dest_dir> [keep]}"
KEEP="${3:-7}"

[ -d "$SRC" ] || { echo "❌ Source not found: $SRC"; exit 1; }
mkdir -p "$DEST"

NAME="$(basename "$SRC")-$(date +%Y%m%d-%H%M%S).tar.gz"
echo "💾 Backing up $SRC → $DEST/$NAME ..."
tar -czf "$DEST/$NAME" -C "$(dirname "$SRC")" "$(basename "$SRC")"
echo "✅ Done: $(du -h "$DEST/$NAME" | cut -f1)"

# Rotation: keep only the N newest
COUNT=$(ls -1 "$DEST"/"$(basename "$SRC")"-*.tar.gz 2>/dev/null | wc -l)
if [ "$COUNT" -gt "$KEEP" ]; then
    ls -1t "$DEST"/"$(basename "$SRC")"-*.tar.gz | tail -n +"$((KEEP + 1))" | xargs rm -f
    echo "🧹 Rotated: keeping newest $KEEP backups."
fi
