#!/bin/bash
#--------------------------------------------------------------------------------------------------
#-- psuForceLogout
#--------------------------------------------------------------------------------------------------
# Program    : psuForceLogout
# To Complie : n/a
#
# Purpose    : Force user logout
#
# Called By  : IdleLogout.app, TEM (As needed)
# Calls      :
#
# Author     : Rusty Myers <rzm102@psu.edu>
# Based Upon :
#
# Note       : 
#
# Revisions  : 
#           2014-03-18 <rzm102>   Initial Version
#
# Version    : 1.0
#--------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------
#-- Log - Echo messages with date and timestamp
#--------------------------------------------------------------------------------------------------
Log ()
{
	logText=$1
	# indent lines except for program entry and exit
	if [[ "${logText}" == "-->"* ]];then
		logText="${logText}`basename $0`: launched..."
	else
		if [[ "${logText}" == "<--"* ]];then
			logText="${logText}`basename $0`: ...terminated" 
		else
		logText="   ${logText}"
		fi
	fi
	date=$(/bin/date)
	echo "${date/E[DS]T /} ${logText}"
}

Log "-->"

Log "Found User $USER"
Log "Killing Apps"

kill -9 `ps axxx | grep "/Applications" | awk '{print $1}'`
Log "Log out user wihtout prompt"
osascript -e 'tell application "System Events"'	-e 'keystroke "q" using {command down, shift down, option down}' -e 'end tell'

# Original https://jamfnation.jamfsoftware.com/discussion.html?id=9902
## Get the logged in user's name
# loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
## Get the PID of the logged in user
# loggedInPID=$( ps -axj | awk "/^$loggedInUser/ && /Dock.app/ {print \$2;exit}" )

## Use the above to run Applescript command to logout using keystroke commands
# /bin/launchctl bsexec "${loggedInPID}" sudo -iu "${loggedInUser}" "/usr/bin/osascript -e 'tell application \"System Events\" to keystroke \"q\" using {command down, option down, shift down}'"
Log "<--"
