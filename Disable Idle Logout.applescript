if getPID("idle") = 0 then
	display dialog "Idle time is not currently being monitored." buttons {"OK"} default button "OK"
	return
end if

set CR to return
set CRCR to return & return

set warnMsg to "                         •WARNING•"
set warnMsg to warnMsg & CRCR & "You are about to disable the automatic idle logout feature, which logs you out if you are idle too long. "
set warnMsg to warnMsg & CRCR & "Disabling this feature will expose you to the following problems "
set warnMsg to warnMsg & "should you leave the Mac unattended and remain logged in:"
set warnMsg to warnMsg & CRCR & "1) Others can use this Mac to access your files."
set warnMsg to warnMsg & CRCR & "2) Others can use this Mac to charge printing to your Penn State Access Account."
set warnMsg to warnMsg & CRCR & "3) Others can use this Mac to pose as you."
set warnMsg to warnMsg & CRCR & "Do you agree to stay in the vicinity of this computer to prevent such abuses?"

set userSelection to the button returned of (display dialog warnMsg with icon 2 buttons {"Cancel Request", "I Agree. Disable Auto Logout."} default button 1)

if userSelection contains "cancel" then
	display dialog "Request cancelled by user" buttons {"OK"} default button 1
	return
end if

killApp("idle")

if getPID("idle") = 0 then
	display dialog "Automatic Idle Logout has been disabled." buttons {"OK"} default button "OK"
else
	display dialog "There was a problem with disabling Automatic Idle Logout." buttons {"OK"} default button "OK"
end if

--••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
--•                        subroutines follow                        •
--••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

----------------------------------------------------------------------
-- getAppCount - return count of apps
----------------------------------------------------------------------
on getAppCount(appName)
	set appCounter to (do shell script ("pid=`/bin/ps auxww | /usr/bin/grep -v grep | /usr/bin/grep -i -c " & quoted form of appName & "` ; [[ -n $pid ]] && echo $pid || echo 0 ")) as integer
	return appCounter
end getAppCount


----------------------------------------------------------------------
-- getPID - return an app's processor id number
----------------------------------------------------------------------
on getPID(appName)
	set appPID to (do shell script ("pid=`/bin/ps auxww | /usr/bin/grep -v grep | /usr/bin/grep -v psuGetPID | /usr/bin/grep -i " & quoted form of appName & " $appName | /usr/bin/awk '{print $2}'` ; [[ -n $pid ]] && echo $pid || echo 0 ")) as integer
	return appPID
end getPID


----------------------------------------------------------------------
-- killApp - kill all running copies of an app
----------------------------------------------------------------------
on killApp(appName)
	set appKilled to false
	repeat while getAppCount(appName) > 0
		set appPID to getPID(appName)
		if appPID ≠ 0 then
			try
				do shell script ("/bin/kill -9 " & appPID)
			end try
			set appKilled to true
			delay 1
		end if
	end repeat
end killApp


