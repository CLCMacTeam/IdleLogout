IdleLogout.app
==============

Description
------------
Application to log out users after a specified period of time. The user will see a prompt with a countdown asking them if they wish to log out or continue working ("More Time"). 

Download app: [Idle Logout.app](https://github.com/rustymyers/IdleLogout/blob/master/IdleLogout%20app/Idle%20Logout.app1.0b1.zip?raw=true)

Background
------------
Idle Logout.app was written in RealStudio 2012 R2. It uses the ioreg command to determine how long USB devices have been idle. Once the idle limit is meet, the computer is forcibly restarted to log out any users.

The terminal command we use to check idle seconds on USB devices is:
> /bin/echo $((`/usr/sbin/ioreg -c IOHIDSystem | /usr/bin/sed -e '/HIDIdleTime/ !{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q'` / 1000000000))"

Important Notes
-------------
Idle Logout.app can be run at login with a LaunchAgent under the users context. **In order for the application to work, the /etc/sudoers file needs to be edited to allow all users to run the "psuRebootNow.pl" script (included in the repo under 'IdleLogout app' folder).** View the "IdleLogoutSudoers.sh" script (included in the repo under 'IdleLogout app' folder) to see what changes are made to the /etc/sudoers file. The script can be used as a postflight script in a package while deploying the app.

Preferences
-------------
The Idle Logout.app looks for a preference file in /Library/CLMadmin/Config named "edu.psu.its.clc.IdleLogoutSettings.plist" (included in the repo under 'IdleLogout app' folder). It looks for the following key/string pairs in the plist. If they are missing, it will use the defaults:

* IgnoreUser = Ignore the username, don't force logout.
* IgnoreGroup = Ignore anyone in this group, don't force logout.
* ComputerIdleAfterNumSeconds = Number of seconds before considering the computer abandoned.
* IdleLoopDelaySeconds = Number of seconds to wait between checking the usb idle seconds.
* WaitForUserPromptSeconds = Number of seconds to wait for user to respond to logout prompt.

Default Values if plist is not installed:

* IgnoreUser = "macadmin"
* IgnoreGroup = "admin"
* ComputerIdleAfterNumSeconds = "600"
* IdleLoopDelaySeconds = "30"
* WaitForUserPromptSeconds = "90"

Attribution
------------
Application Icon modified from original, used with CC license:
From http://www.flickr.com/photos/23453447@N02/5107438855/sizes/o/in/photostream/
By zyrquel: http://www.flickr.com/photos/23453447@N02/