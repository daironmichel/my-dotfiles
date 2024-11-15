#!/usr/bin/env bash

ALERT_IF_IN_NEXT_MINUTES=60
ALERT_POPUP_BEFORE_SECONDS=60
ALERT_POPUP_FLAG="$HOME/.tmux/custom/scripts/get_meetings_popup_flag.tmp"
NERD_FONT_FREE="󱁕"
NERD_FONT_MEETING="󰤙"

# RED='\033[0;31m'
# GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
# CYAN='\033[0;36m'
# WHITE='\033[0;37m'
NC='\033[0m' # No Color

get_next_meeting() {
  meetings=$(icalBuddy \
    --includeEventProps "title,datetime,location" \
    --propertyOrder "datetime,title,location" \
    --propertySeparators "| :: |" \
    --noCalendarNames \
    --dateFormat "%A" \
    --timeFormat "%I:%M %p" \
    --includeOnlyEventsFromNowOn \
    --limitItems 2 \
    --excludeAllDayEvents \
    --separateByDate \
    --bullet "" \
    --excludeCals "Personal,daironmichel@gmail.com" \
    eventsToday)

  lines=()

  # convert the output into an array of lines
  while IFS= read -r line; do
    lines+=("$line")
  done <<<"$meetings"

  # for line in "${lines[@]}"; do
  #   echo "$line"
  # done

  # This is an example output of the lines
  #
  # 0 |today:
  # 1 |------------------------
  # 2 |04:00 PM - 05:00 PM :: test 1
  # 3 |04:30 PM - 05:00 PM :: test 2 :: location: http://test.com

  # parse the output
  first_event_time_range=$(echo "${lines[2]}" | awk -F ' :: ' '{print $1}')
  first_event_title=$(echo "${lines[2]}" | awk -F ' :: ' '{print $2}')
  first_event_location=$(echo "${lines[2]}" | awk -F ' :: ' '{print $3}')

  first_event_start=$(echo "$first_event_time_range" | awk -F ' - ' '{print $1}')
  first_event_end=$(echo "$first_event_time_range" | awk -F ' - ' '{print $2}')

  second_event_time_range=$(echo "${lines[3]}" | awk -F ' :: ' '{print $1}')
  second_event_title=$(echo "${lines[3]}" | awk -F ' :: ' '{print $2}')
  second_event_location=$(echo "${lines[3]}" | awk -F ' :: ' '{print $3}')

  second_event_start=$(echo "$second_event_time_range" | awk -F ' - ' '{print $1}')
  second_event_end=$(echo "$second_event_time_range" | awk -F ' - ' '{print $2}')

  # initialize vars
  epoc_now=$(date +%s)
  first_event_minutes_till_meeting=1440  # 24h
  first_event_start_epoc_diff=86400      # 24h
  second_event_minutes_till_meeting=1440 # 24h
  second_event_start_epoc_diff=86400     # 24h

  if [[ "$first_event_time_range" != "" ]]; then
    first_event_start_epoc=$(date -j -f "%I:%M %p" "$first_event_start" +%s)
    first_event_start_epoc_diff=$((first_event_start_epoc - epoc_now))
    first_event_minutes_till_meeting=$((first_event_start_epoc_diff / 60))
  fi

  if [[ "$second_event_time_range" != "" ]]; then
    second_event_start_epoc=$(date -j -f "%I:%M %p" "$second_event_start" +%s)
    second_event_start_epoc_diff=$((second_event_start_epoc - epoc_now))
    second_event_minutes_till_meeting=$((second_event_start_epoc_diff / 60))
  fi

  # next meeting details
  title=$first_event_title
  location=${first_event_location:-"location: <NONE>"}
  start_time=$first_event_start
  end_time=$first_event_end
  minutes_till_meeting=$first_event_minutes_till_meeting
  epoc_diff=$first_event_start_epoc_diff

  # if the second event
  if [[ second_event_minutes_till_meeting -le 15 ]]; then
    title=$second_event_title
    location=${second_event_location:-"location: <NONE>"}
    start_time=$second_event_start
    end_time=$second_event_end
    minutes_till_meeting=$second_event_minutes_till_meeting
    epoc_diff=$second_event_start_epoc_diff
  fi
}

display_popup() {
  # check if we are bofore the threshold and return
  if [[ $epoc_diff -gt $ALERT_POPUP_BEFORE_SECONDS ]]; then
    return 0
  fi

  # check if we are after meeting started
  #   if flag present, remove, then return
  if [[ $epoc_diff -lt 0 ]]; then
    if [[ -e "$ALERT_POPUP_FLAG" ]]; then
      rm -f "$ALERT_POPUP_FLAG"
    fi
    return 0
  fi

  # check if we are in the threshold and flag is present, then return
  if [[ -e "$ALERT_POPUP_FLAG" ]]; then
    return 0
  fi

  # we are in the threshold and the flag is not present.
  # create the flag and show the popup
  touch "$ALERT_POPUP_FLAG"
  tmux display-popup \
    -S "fg=#eba0ac" \
    -w50% \
    -h50% \
    -d '#{pane_current_path}' \
    -T meeting \
    "echo '${YELLOW}󰅐  $start_time - $end_time${NC}\n    ${MAGENTA}  $title\n${NC}    ${BLUE}  $location${NC}'"
}

print_tmux_status() {
  if [[ $minutes_till_meeting -lt $ALERT_IF_IN_NEXT_MINUTES && $minutes_till_meeting -gt -60 ]]; then
    echo "$NERD_FONT_MEETING $title ($minutes_till_meeting min)"
  else
    echo "$NERD_FONT_FREE"
  fi

  display_popup
}

main() {
  get_next_meeting
  print_tmux_status
}

main
