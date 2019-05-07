on run {input, parameters}
	tell application "iTerm"
		tell current window
			create tab with default profile
			tell current session
				write text ("vim " & quote & POSIX path of input & quote & " ; exit")
			end tell
		end tell
	end tell
end run
