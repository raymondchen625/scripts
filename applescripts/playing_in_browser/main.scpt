# This detects there is a tab matches the defined URL list. Grabs its tab title, removes the suffix and return the remaining of the string for display.
on is_running(appName)
  tell application "System Events" to (name of processes) contains appName
end is_running
set chromeRunning to is_running("Google Chrome")
set result to "---"
if chromeRunning then
  set toRemoveSuffixInTitle to " - YouTube"
  set urlList to {"http://music.youtube.com/", "https://music.youtube.com/"}
  tell application "Google Chrome"
    repeat with t in tabs of windows
      tell t
        set isTargetTab to false
        repeat with a from 1 to length of urlList
          set theCurrentListItem to item a of urlList
          if (URL starts with theCurrentListItem) then
            set isTargetTab to true
            exit repeat
          end if
        end repeat
        if isTargetTab then
          set tabtitle to title of t as string
          set result to tabtitle
        end if
      end tell
    end repeat
  end tell
  set AppleScript's text item delimiters to toRemoveSuffixInTitle
  set result to text item 1 of tabtitle
end if
return result