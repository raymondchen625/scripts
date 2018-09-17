# Sends a space keystroke to the URL matching tab.
set urlList to {"http://music.youtube.com/", "https://music.youtube.com/"}
tell application "System Events"
  set frontApp to first application process whose frontmost is true
end tell
tell application "Google Chrome"
  activate
  set i to 0
  set activeTab to 0
  repeat with w in (windows)
    set activeTab to active tab index of w
    set i to i + 1
    set j to 0
    repeat with t in (tabs of w)
      set j to j + 1
      set isTargetTab to false
      repeat with a from 1 to length of urlList
        set theCurrentListItem to item a of urlList
        if (URL of t starts with theCurrentListItem) then
          set isTargetTab to true
          exit repeat
        end if
      end repeat
      if isTargetTab then
        set (active tab index of w) to j
        tell application "System Events"
          keystroke space
        end tell
        tell w to set active tab index to activeTab
      end if
    end repeat
  end repeat
end tell
set frontmost of frontApp to true
