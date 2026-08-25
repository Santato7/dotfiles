#!/bin/bash
# CPU %, RAM used/total, CPU package temperature, and root disk used/total,
# for the santato.sysinfo bar widget.

cpu=$(top -bn1 | awk '
  /^%?Cpu/ {
    gsub(/,/, "")
    for (i = 1; i <= NF; i++) {
      if ($(i + 1) == "id") { printf "%.0f%%", 100 - $i; exit }
    }
  }
')

mem=$(awk '
  /^MemTotal:/ { total = $2 }
  /^MemAvailable:/ { avail = $2 }
  END { printf "%.1fG/%.0fG", (total - avail) / 1024 / 1024, total / 1024 / 1024 }
' /proc/meminfo)

temp=$(sensors 2>/dev/null | awk '
  /^Package id 0:/ { val = $4; gsub(/\+|°C/, "", val); print val "°C"; exit }
')
[[ -z "$temp" ]] && temp="?"

disk=$(df -h / | awk 'NR==2 { print $3"/"$2 }')

printf 'CPU %s  %s  RAM %s  Disk %s' "$cpu" "$temp" "$mem" "$disk"
