#!/bin/bash

# Claude Code Notification Script
# Handles notifications for session completion and input waiting states

# Debug log
DEBUG_LOG="$HOME/.claude/hooks/debug.log"
echo "[$(date)] Hook triggered" >> "$DEBUG_LOG"

# Read hook data from stdin
HOOK_DATA=$(cat)
echo "[$(date)] Received data: $HOOK_DATA" >> "$DEBUG_LOG"

# Parse JSON data using simple grep/sed (for basic reliability)
EVENT_TYPE=$(echo "$HOOK_DATA" | grep -o '"hook_event_name":"[^"]*"' | sed 's/"hook_event_name":"\([^"]*\)"/\1/')
SESSION_ID=$(echo "$HOOK_DATA" | grep -o '"session_id":"[^"]*"' | sed 's/"session_id":"\([^"]*\)"/\1/')

# Function to display macOS notification with sound
notify() {
    local title="$1"
    local message="$2"
    local sound="$3"

    # Display notification with sound
    osascript -e "display notification \"$message\" with title \"$title\" sound name \"$sound\""
}

# Function to play system sound
play_sound() {
    local sound_file="$1"
    if [ -f "$sound_file" ]; then
        afplay "$sound_file" &
    fi
}

# Log the parsed event type
echo "[$(date)] Event type: $EVENT_TYPE" >> "$DEBUG_LOG"

# Handle different event types
case "$EVENT_TYPE" in
    "Stop")
        echo "[$(date)] Handling Stop event" >> "$DEBUG_LOG"
        # Task completion notification
        notify "Claude Code" "タスクが完了しました 🎉" "Glass"
        ;;

    "Notification")
        # Check if it's an idle prompt (60+ seconds waiting)
        if echo "$HOOK_DATA" | grep -q "idle_prompt"; then
            notify "Claude Code" "入力を待機しています... ⏳" "Ping"
            play_sound "/System/Library/Sounds/Ping.aiff"
        elif echo "$HOOK_DATA" | grep -q "permission_prompt"; then
            notify "Claude Code" "許可が必要です 🔐" "Funk"
            play_sound "/System/Library/Sounds/Funk.aiff"
        fi
        ;;

    "SessionEnd")
        # Session end notification
        notify "Claude Code" "セッションが終了しました 👋" "Pop"
        play_sound "/System/Library/Sounds/Pop.aiff"
        ;;

    "SubagentStop")
        # Subagent completion notification (quieter)
        notify "Claude Code" "サブタスクが完了しました ✓" "Tink"
        ;;

    *)
        # Debug: Log unknown events
        echo "[$(date)] Unknown event: $EVENT_TYPE" >> ~/.claude/hooks/debug.log
        ;;
esac

# Terminal bell for WezTerm (if running in WezTerm)
if [ -n "$WEZTERM_PANE" ]; then
    printf '\a'
fi

exit 0
