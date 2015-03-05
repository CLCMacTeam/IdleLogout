IdleLogout.app
==============

Description
------------
Application to log out users after a specified period of time. The user will see a prompt with a countdown asking them if they wish to log out or continue working ("More Time"). Users can disable the Idle Logout process using the "Disable Idle Logout.applescript".

Screen Shot of Count Down Window:
![window]

Download app: [Idle Logout.app](https://github.com/CLCMacTeam/IdleLogout/blob/LogoutNotRestart/IdleLogout%20app/Idle%20Logout.app1.1b2.zip)

Background
------------
Idle Logout.app was written in RealStudio 2014 R2.1. It uses the ioreg command to determine how long USB devices have been idle. Once the idle limit is meet, the computer is forcibly restarted to log out any users.

The terminal command we use to check idle seconds on USB devices is:
> /bin/echo $((`/usr/sbin/ioreg -c IOHIDSystem | /usr/bin/sed -e '/HIDIdleTime/ !{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q'` / 1000000000))"

Important Notes
-------------
Idle Logout.app should be run at login with a LaunchAgent under the users context. **UPDATE: The Idle Logout.app is self contained and will force a user logout without the need for external scripts!** The Idle Logout.app will write log files into the /Users/Shared/IdleLogout folder.

You can deploy the "Disable Idle Logout.applescript", as a compiled app, to give users an easy way to stop the Idle Logout process. This is helpful in locations where users need to allow processes to run for longer than you're normal logout time.

**The Idle Logout App will force close any applications the user has open. This will not save any data!**

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
* Use CFPrefernces for pref file
* Update code to Cocoa
** Only update UI from main thread

Completed
------------
* 01/2015 - The path to the logout script should be set in the preference file OR the script should be part of the app.
** 01/2015 - Make it part of the .app, create a new method to log out
* 01/2015 - Add preference key for window wording.

Attribution
------------
Application Icon modified from original, used with CC license:
From http://www.flickr.com/photos/23453447@N02/5107438855/sizes/o/in/photostream/
By zyrquel: http://www.flickr.com/photos/23453447@N02/

Full Screen Shot of Countdown Window:
![full]

[full]: https://github.com/CLCMacTeam/IdleLogout/blob/master/IdleLogout%20app/screenshots/full.png?raw=true "Full Screen Shot"
[window]: https://github.com/CLCMacTeam/IdleLogout/blob/master/IdleLogout%20app/screenshots/window.png?raw=true "Windowed Screen Shot"
