IdleLogout.app
==============

Description
------------
Application to log out users after a specified period of time. The user will see a prompt with a countdown asking them if they wish to log out or continue working ("More Time"). 

Download app: [Idle Logout.app](https://github.com/rustymyers/IdleLogout/blob/master/IdleLogout%20app/Idle%20Logout.app1.0b1.zip?raw=true)

Background
------------
Idle Logout.app was written in RealStudio 2014 R1. It uses the ioreg command to determine how long USB devices have been idle. Once the idle limit is meet, the computer is forcibly restarted to log out any users.

The terminal command we use to check idle seconds on USB devices is:
> /bin/echo $((`/usr/sbin/ioreg -c IOHIDSystem | /usr/bin/sed -e '/HIDIdleTime/ !{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q'` / 1000000000))"

Important Notes
-------------
Idle Logout.app should be run at login with a LaunchAgent under the users context. **In order for the application to work, the /Library/CLMadmin/psuForceLogOut.sh needs to allow all users to execute the script (included in the repo under 'IdleLogout app' folder).** The Idle Logout.app will write log files into the /Users/Shared/IdleLogout folder.

Preferences
-------------
The Idle Logout.app looks for the preference file "/Library/CLMadmin/Config/edu.psu.its.clc.IdleLogoutSettings.plist" (included in the repo under 'IdleLogout app' folder). It looks for the following key/string pairs in the plist. If they are missing, it will use the defaults:

* IgnoreUser = Ignore the username, don't force logout.
* IgnoreGroup = Ignore anyone in this group, don't force logout.
* ComputerIdleAfterNumSeconds = Number of seconds before considering the computer abandoned.
* IdleLoopDelaySeconds = Number of seconds to wait between checking the usb idle seconds.
* WaitForUserPromptSeconds = Number of seconds to wait for user to respond to logout prompt.
* WindowTitle = Changes the name name shown in the logout window. Uses String.

Default Values if plist is not installed:

* IgnoreUser = "macadmin"
* IgnoreGroup = "admin"
* ComputerIdleAfterNumSeconds = "600"
* IdleLoopDelaySeconds = "30"
* WaitForUserPromptSeconds = "90"
* WindowTitle = "PSU Idle Logout"

ToDo
-------------
* The path to the logout script should be set in the preference file OR the script should be part of the app.
* Add prefernece key for window wording.
* Use CFPrefernces for pref file

Attribution
------------
Application Icon modified from original, used with CC license:
From http://www.flickr.com/photos/23453447@N02/5107438855/sizes/o/in/photostream/
By zyrquel: http://www.flickr.com/photos/23453447@N02/
