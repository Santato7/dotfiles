#!/bin/bash
# CPU %, RAM used/total, CPU package temperature, and root disk used/total,
# for the santato.sysinfo bar widget. Colored with the active Omarchy theme's
# palette (~/.local/state/omarchy/current/theme/colors.toml) so it follows
# theme switches; falls back to Ristretto's colors if that file is missing.

theme_colors="$HOME/.local/state/omarchy/current/theme/colors.toml"
color() {
  awk -F'"' -v key="$1" -v fallback="$2" '
    $0 ~ "^" key " *=" { print $2; found = 1 }
    END { if (!found) print fallback }
  ' "$theme_colors" 2>/dev/null
}
cyan=$(color cyan "#85dacc")
magenta=$(color magenta "#a8a9eb")
orange=$(color orange "#fb9a77")
green=$(color green "#adda78")
yellow=$(color yellow "#f9cc6c")
red=$(color red "#fd6883")
muted=$(color muted "#72696a")

cpu=$(top -bn1 | awk '
  /^%?Cpu/ {
    gsub(/,/, "")
    for (i = 1; i <= NF; i++) {
      if ($(i + 1) == "id") { printf "%.0f", 100 - $i; exit }
    }
  }
')

mem=$(awk '
  /^MemTotal:/ { total = $2 }
  /^MemAvailable:/ { avail = $2 }
  END { printf "%.1fG/%.0fG", (total - avail) / 1024 / 1024, total / 1024 / 1024 }
' /proc/meminfo)

temp=$(sensors 2>/dev/null | awk '
  /^Package id 0:/ { val = $4; gsub(/\+|°C/, "", val); print val; exit }
')

if [[ -n "$temp" ]]; then
  temp_color=$(awk -v t="$temp" -v g="$green" -v y="$yellow" -v r="$red" '
    BEGIN { if (t + 0 >= 70) print r; else if (t + 0 >= 45) print y; else print g }
  ')
  temp_display="${temp}°C"
else
  temp_color="$red"
  temp_display="?"
fi

disk=$(df -h / | awk 'NR==2 { print $3"/"$2 }')

sep="<font color=\"$muted\"> | </font>"

printf '<font color="%s">CPU %s%%</font>%s<font color="%s">%s</font>%s<font color="%s">RAM %s</font>%s<font color="%s">Disk %s</font>' \
  "$cyan" "$cpu" "$sep" "$temp_color" "$temp_display" "$sep" "$magenta" "$mem" "$sep" "$orange" "$disk"
