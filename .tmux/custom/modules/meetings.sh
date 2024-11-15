# Depends on get_meetings.sh custom script
# Make sure it is executable chmode u+x ~/.tmux/custom/scripts/get_meetings.sh

show_meetings() {
  local index=$1
  local icon
  local color
  local text
  local module
  icon="$(get_tmux_option "@catppuccin_meetings_icon" "")"
  color="$(get_tmux_option "@catppuccin_meetings_color" "$thm_blue")"
  text="$(get_tmux_option "@catppuccin_meetings_text" "#( $HOME/.tmux/custom/scripts/get_meetings.sh )")"
  module=$(build_status_module "$index" "$icon" "$color" "$text")
  echo "$module"
}
