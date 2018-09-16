set result to "YouTube Music"
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
      if isTargetTabthen then
        set tabtitle to title of t as string
        set result to tabtitle
      end if
    end tell
  end repeat
end tell
set AppleScript's text item delimiters to " - YouTube"
set result to text item 1 of tabtitle
if (result is equal to "YouTube Music") then
  return "---"
else
  return result
end if