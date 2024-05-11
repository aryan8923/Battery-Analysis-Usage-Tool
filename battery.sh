#!/bin/bash
:'This file is part of Battery Usage Analysis Tool.

Battery Usage Analysis Tool is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Battery Usage Analysis Tool is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with Battery Usage Analysis Tool. If not, see <https://www.gnu.org/licenses/>.'

echo "Enter time interval for monitoring (in seconds) : "
read time_interval

data_file="data_battery.txt"
brightness_file="/sys/class/backlight/intel_backlight/actual_brightness"
kbd_backlight_brightness_file="/sys/class/leds/asus::kbd_backlight/brightness"
batterylevel_file="/sys/class/power_supply/BAT0/capacity"
charging_status_file="/sys/class/power_supply/BAT0/status"

file_exists() {
  if [ -e "$1" ]; then
    echo 1
  else
    echo 0
  fi
}

read_value() {
   if [[ "$1" -eq 0 ]]; then
     local nan="Nan"
      echo "$nan"
  elif [[ "$1" -eq 1 ]]; then
    local file_path="$2"
    local file_content=$(cat "$file_path")
    echo "$file_content"
   fi 
}


brightness_file_exists=$(file_exists "$brightness_file")
kbd_backlight_brightness_file_exists=$(file_exists "$kbd_backlight_brightness_file")
batterylevel_file_exists=$(file_exists "$batterylevel_file")
charging_status_file_exists=$(file_exists "$charging_status_file")


if [ ! -f "$data_file" ]; then 
  echo "Creating $data_file..."
  echo "date,hour,minutes,seconds,battery_level,charging_status,brightness,cpu_usage,kbd_backlight_brightness" > "$data_file"
  echo "File created successfully."
else 
  echo "$data_file already exists. Skipping creation..."
fi

while true; do
  brightness=$(read_value "$brightness_file_exists" "$brightness_file" )

  kbd_backlight_brightness=$(read_value "$kbd_backlight_brightness_file_exists" "$kbd_backlight_brightness_file")

  batterylevel=$(read_value "$batterylevel_file_exists" "$batterylevel_file")

  charging_status=$(read_value "$charging_status_file_exists" "$charging_status_file")

  if [ "$charging_status" == "Charging" ]; then
    charging_status=1
  elif [ "$charging_status" == "Discharging" ]; then
    charging_status=0
  fi

  cpuusage=$(top -bn1 | awk 'NR > 7 && $9 ~ /^[0-9.]+$/ { sum += $9; count++ } END { print sum/count }')

  date=$(date +"%d-%m-%Y")
  hour=$(date +"%H")
  minute=$(date +"%M")
  seconds=$(date +"%S")

  echo "$date,$hour,$minute,$seconds,$batterylevel,$charging_status,$brightness,$cpuusage,$kbd_backlight_brightness" >> "$data_file"

  sleep "$time_interval"

done


