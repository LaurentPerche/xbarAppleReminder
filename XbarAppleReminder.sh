#!/bin/sh
# <xbar.title>Todo List for menu bar (Updated)</xbar.title>
# <xbar.version>v1.1</xbar.version>
# <xbar.author>Julian Naumann / Updated by ChatGPT</xbar.author>
# <xbar.author.github>JulianNaumann</xbar.author.github>
# <xbar.desc>
#   Display a todo list in the menu bar with items taken from macOS Reminders.app 
#   from the list called "Today". The menu bar shows the first (next) reminder,
#   and clicking it opens a dropdown listing all active reminders. Click any 
#   reminder in the dropdown to mark it completed.
# </xbar.desc>
# <xbar.image>https://i.imgur.com/d4cBUKW.png</xbar.image>
# <xbar.dependencies>bash,osascript</xbar.dependencies>
# <xbar.abouturl>https://github.com/JulianNaumann/bitbar-todolist</xbar.abouturl>

# Icon credit, all icons from <https://www.flaticon.com>:
# - Bell icon made by Nice And Serious <https://niceandserious.com>
# - Todo list icon made by Freepik <https://www.freepik.com>
# - Check icon made by Smashicons <https://smashicons.com>

########################################################################
# When a reminder is clicked, it is passed as:
#   param1 = "done"
#   param2 = the 1-indexed position in the active reminders list
########################################################################

if [ "$1" = "done" ]; then
    # Use the second parameter (or default to 1) to know which reminder to mark done.
    index="${2:-1}"
    osascript -e "tell application \"Reminders\"
        set activeReminders to (reminders of list \"Today\" whose completed is false)
        if (count of activeReminders) is greater than or equal to $index then
            set todo to item $index of activeReminders
            set completed of todo to true
        end if
    end tell"
    exit
fi

########################################################################
# Get the list of active reminders from the "Today" list.
########################################################################
todos_raw=$(osascript -e 'tell application "Reminders"
    set activeReminders to (reminders of list "Today" whose completed is false)
    if activeReminders is not {} then
        set output to ""
        repeat with r in activeReminders
            set output to output & (name of r) & "\n"
        end repeat
        return output
    else
        return "No Todos!"
    end if
end tell')

########################################################################
# Base64 encoded image for the todo list icon (feel free to change)
########################################################################
image=iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAACXBIWXMAABYlAAAWJQFJUiTwAAABWWlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iWE1QIENvcmUgNS40LjAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp0aWZmPSJodHRwOi8vbnMuYWRvYmUuY29tL3RpZmYvMS4wLyI+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgpMwidZAAADs0lEQVRIDbWWW4iNURSAz5mLGeM2TSnXcZkil5SSB28UESGS8ELjlgfxQIkHeUARHlxilFBKKF5mEiajSGZeeCMNRVPzgJLrYI7v+8+/z5zTOWbmhFXfWXvvf+2911p77d1JpFKppCQQ9EH4H3KbRcvcw58k0m0H6UqrxBX0R6iGX/FYMaoE4x9QCuugAsIeUWQleLAankI3nIUJGP2VsIbrvoTWnIUYKIN7oHxLq1S9RrT1tihhTpQ+dBW0w5OcBRjQk/FwA5QtMFQjdHTG/dXxHFPo3EGQs2Hw3qLZBvPhJ+yEOaBEBZVuFv6lBlLxFx0vof+9sGUiETb0+0Aojw2z227YK0bvpvALrIGaeB2LMN9hvYJauAZKPQyOJ/VLYV8Ow2A0tIGF55hF0xYWiQ6XjpFegHlgOs6Dqb2I8Vb0IMj2Vq+9LgMg2C+lfRhMbx3cgpCZkHKGEBY1wmXQCqakAfR0InyF3kT7aTADumLDvfG6FfRfQ6ZKQ4R+12Mvp14ZjZX2FpZBJRhx9nnotfONsIOz+8DCi2hPhZOgmIH8hwND72EzKOEebo6m9POHednOR7MY6/UejsPgOigboaiiyfaLuRtgHnhUryAvpaZqBywEU7cHOqAR4yq030O6aUZiSh0nm8nP2E2mPRcssKPQBI/A9TLXLy8NfFQ0sFiGo+/ACPgMPsaKG/k4D4F32C1Az4YzoLSDAWjj3c483GFDvT0BY2ElHIIHMBI6we9fwQ1DZHr+Cd7DQKK8zMZmaBasov+CvseS2Yx2WvhQqGg2he99aeYbsddrMIwJ9nG/HZ13hnpxDMy/qTkN98FFosVsFxIi8UnDLHpDjfgT7RrGjPwbZM7P+dkd02XflIW2FREt+CeNbSR89wEwwlEM3ESfQrtewaLxw3Yw/17kLfAYnjNxPdpKtQCyozUrA0D7S7Ac9oPj06ElbjvHIHqERb0vtRAe781+pT8J+vO0TcVuJgQ5EM+vZKDg06YXu2AJmIJ9GL4hTU3oNfQLPW1GYsl7Tp3Yej0W055G+whaybkSDoRrYduyN22OfYFImHwztHvTbIZpshEbH4tS2r6hee9o2NAcW5l1sAKOw0MwrXrZl0QLY2sthKJzLPvMe9bA0Ht4F5TweNdrQd9FihLmRIGg8x7vsJjn0QDPwMo7B83gtfBbUcIc60DxfJ2fidTI/NPj4FXaU9AzwCdpN/1qdN45MNaXGIj14H32mFrCPoZOOzpwc290ytq0+me/3lWd6P4NwGhT56kWXgsAAAAASUVORK5CYII=

########################################################################
# Split the AppleScript output into an array (each reminder on its own line)
########################################################################
IFS=$'\n' read -rd '' -a todos <<< "$todos_raw"

########################################################################
# If there are no active reminders, show "No Todos!" and exit.
########################################################################
if [ "${todos[0]}" = "No Todos!" ]; then
    echo "No Todos! | length=30 templateImage=$image"
    exit
fi

########################################################################
# Display the first reminder as the menu bar title.
########################################################################
main_item="${todos[0]}"
echo "$main_item | length=30 templateImage=$image"

########################################################################
# Output a separator to create a dropdown list.
########################################################################
echo '---'

########################################################################
# For each active reminder, list it as a clickable dropdown item.
# Clicking an item runs this script with param1 "done" and param2 equal to
# its 1-indexed position in the active reminders list.
########################################################################
for i in "${!todos[@]}"; do
    todo="${todos[$i]}"
    # AppleScript uses 1-based indexing.
    index=$((i+1))
    echo "$todo | length=30 bash='$0' param1=done param2=$index terminal=false refresh=true"
done XbarAppleReminder.sh