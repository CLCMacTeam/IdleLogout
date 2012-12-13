#!/bin/bash

# Written by Rusty Myers
# 2012-11-06

# postflight to tell etc/sudoers to add code
DEST_VOLUME="${3}"
TIME=`date "+%Y-%m-%d-%H-%M-%S"`

# Allow Runtime to run with root privileges without prompting for an admin password

# check sudoers for psuRebootNow.pl
RUN_AS_ROOT=`grep "psuRebootNow.pl" "${DEST_VOLUME}"/etc/sudoers`

if [ -n "${RUN_AS_ROOT}" ] # If it's there
then
	# Remove it from /etc/sudoers if it exists
	sed /psuRebootNow.pl/d "${DEST_VOLUME}"/etc/sudoers > "${DEST_VOLUME}"/tmp/sudoers
	# Make a copy of the current version
	mv "${DEST_VOLUME}"/etc/sudoers "${DEST_VOLUME}"/etc/sudoers."${TIME}"
	# Replace old version with new version
	mv "${DEST_VOLUME}"/tmp/sudoers "${DEST_VOLUME}"/etc/sudoers
else
	# Make a copy of the current version
	cp "${DEST_VOLUME}"/etc/sudoers "${DEST_VOLUME}"/etc/sudoers."${TIME}"
fi
# Add it back into /etc/sudoers
echo 'ALL		ALL=NOPASSWD:/Library/CLMshared/psuRebootNow.pl' >> "${DEST_VOLUME}"/etc/sudoers
  
# Check permissions and reload sudoers file
chmod 440        "${DEST_VOLUME}"/etc/sudoers
chown root:wheel "${DEST_VOLUME}"/etc/sudoers
visudo -c

exit 0
