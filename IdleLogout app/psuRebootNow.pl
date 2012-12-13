#!/usr/bin/perl -w
#
#--------------------------------------------------------------------------------------------------
#-- psuRebootRequested.pl
#--------------------------------------------------------------------------------------------------
# Program    : psuRebootRequested.pl
#
# Purpose    : Reboot computer
#
# Loaded By  : launchd
# Called By  : psuKioskIdleLogout.app touching file /tmp/psu_reboot_requested
#
# Author     : <hkr@psu.edu> Ken Rosenberry
#
# Revisions  : 2009/08/18 <hkr> Initial version
#            : 2010/06/21 <hkr> no longer using /tmp/psu_reboot_now flag file
#--------------------------------------------------------------------------------------------------

# Get name of program for log records.
use File::Basename;
my ( $programName ) = basename($0);

LogData ("-->");

# psuCurrentUser.dat file contains the last logged in user.
# Remove this file, otherwise RunMaint tasks won't run because it looks like a user is logged in.
$current_user_dat_file = '/Library/PSUtemp/psuCurrentUser.dat';
if (-f $current_user_dat_file)
	{
	LogData("Remove current user file: $current_user_dat_file");
	system "/bin/rm $current_user_dat_file";
	}

LogData("Rebooting Now!");
LogData ("<--");

system '/sbin/reboot';

exit 0;

#--------------------------------------------------------------------------------------------------
#-- LogData - Print message to log file.
#--------------------------------------------------------------------------------------------------
sub LogData
    {
    my $text = $_[0] ;

    if ( substr($text, -1, 1) ne "\n") { $text = $text . "\n"; }        ### Log messages must end w/ newline.
    if ( substr($text,  0, 3) eq "-->")
        {
        $text = substr($text,  0, 3) . $programName . ": launched..." . substr($text, 3);
        }
    elsif ( substr($text,  0, 3) eq "<--" )
        {
        $text = substr($text,  0, 3) . $programName . ": ...terminated." . substr($text, 3);
        }
    else
        {
        $text = "   " . $programName . ": " . $text;                    ### All other log records indented.
        }
        
    $text = (scalar localtime) . " " . $text;                           ### Timestamp log records.

    print $text;
    }
