#tag ClassProtected Class IdleLogoutInherits Application	#tag Event		Sub Open()		  Dim debugFileName as string		  Dim theDate as date		  dim mXMLtreeToFollow(-1) as string		  dim mPrefKeyFoundData(-1) as string		  dim mTempFoundPlistData as string = "" // Local variable to use for gathering plist settings		  theDate = new Date		  		  Globals.gAppFolderItem = GetFolderItem("/Users/Shared/", FolderItem.PathTypeShell)		  if Globals.gAppFolderItem.Exists = false then		    // dim Folderexists as boolean		    // Folderexists = LogoutWarning.makeFolder("/Users/Shared/") //Can't make a folder here as a user.		    Globals.gAppFolderItem = GetFolderItem("/tmp/", FolderItem.PathTypeShell)		    MsgBox "Can't find /Users/Shared! Using /tmp/ for logs"		  end		  		  		  // Set the name of the log		  debugFileName = "psuIdleLogout.RUN" + MiscMethods.PadData("0",2,str(theDate.Year),Globals.kLogToFileDisable) _		  + "-" + MiscMethods.PadData("0",2,str(theDate.Month),Globals.kLogToFileDisable) + "-"		  debugFileName = debugFileName + MiscMethods.PadData("0",2,str(theDate.Day),Globals.kLogToFileDisable) + _		  "-" + MiscMethods.PadData("0",2,str(theDate.Hour),Globals.kLogToFileDisable) + "-"		  debugFileName = debugFileName + MiscMethods.PadData("0",2,str(theDate.Minute),Globals.kLogToFileDisable) + _		  "-" + MiscMethods.PadData("0",2,str(theDate.Second),Globals.kLogToFileDisable) + ".log"		  		  // Initilize the log, quit if we can't create the log		  if not (LogToFile.Initialize(debugFileName,Globals.gAppFolderItem)) then		    beep		    MsgBox "Error creating run log file! Exiting..."		    quit		  end if		  		  // Keep only the last 5 logs		  if ( LogToFile.DeleteOldLogs(5) ) then		    LogToFile("Deleted Old Logs")		  end if		  		  		  // CFPref calls		  		  'dim ComputerIdleAfterNumSeconds as Integer = "900"		  'dim IdleLoopDelaySeconds as Integer = "60"		  'dim WaitForUserPromptSeconds = "90"		  		  // Set version number in pref file		  // prefs.Value ("version") = App.pAppVersion		  // dim AppVersionPref as String = prefs.Value("version", App.pAppVersion) // Get version from plist file		  		  'dim ComputerIdleAfterNumSecondsPref as string = prefs.Value("ComputerIdleAfterNumSeconds", App.pComputerIdleAfterNumSeconds)		  'dim IdleLoopDelaySecondsPref as string = prefs.Value("IdleLoopDelaySeconds", App.pIdleLoopDelaySeconds)		  'dim WaitForUserPromptSecondsPref as string = prefs.Value("WaitForUserPromptSeconds", App.pWaitForUserPromptSeconds)		  '		  'LogToFile("CFPrefs Return of ComputerIdleAfterNumSeconds: " + ComputerIdleAfterNumSecondsPref )		  		  		  		  // Are there any users that we should ignore running for?		  if ( PlistHelper.readPlist(LogoutWarning.pDefaultPrefsFSPath, LogoutWarning.pDefaultPrefsFileName, "IgnoreUser", mTempFoundPlistData ) ) then		    		    LogoutWarning.pIgnoreUser = mTempFoundPlistData		    		    LogToFile(CurrentMethodName + ": Found the default key data, = " + str(LogoutWarning.pIgnoreUser) )		    		  else // Failed!		    		    LogToFile(CurrentMethodName + ": Warning! Failed to find the default key 'IgnoreUser', using default of "+ str (LogoutWarning.pIgnoreUser) )		    		  end if		  		  // Are there any groups that we should ignore running for?		  if ( PlistHelper.readPlist(LogoutWarning.pDefaultPrefsFSPath, LogoutWarning.pDefaultPrefsFileName, "IgnoreGroup", mTempFoundPlistData ) ) then		    		    LogoutWarning.pIgnoreGroup = mTempFoundPlistData		    		    LogToFile(CurrentMethodName + ": Found the default key data, = " + str(LogoutWarning.pIgnoreGroup) )		    		  else // Failed!		    		    LogToFile(CurrentMethodName + ": Warning! Failed to find the default key 'IgnoreGroup', using default of "+ str (LogoutWarning.pIgnoreGroup) )		    		  end if		  		  		  // Is this user macadmin?		  if ( MiscMethods.CurrentUsername(LogoutWarning.pIgnoreUser) ) then		    // It is macadmin, quit the app		    LogToFile("Current user is " + LogoutWarning.pIgnoreUser + ", quiting app")		    quit		  else		    LogToFile("User is not " + LogoutWarning.pIgnoreUser + ", continuing")		  end if		  		  // Is this user an admin?		  if ( MiscMethods.CurrentGroup(LogoutWarning.pIgnoreGroup) ) then		    // It is macadmin, quit the app		    LogToFile("Current user is an " + LogoutWarning.pIgnoreGroup + ", quiting app")		    //[p=quit		  else		    LogToFile("User is not an " + LogoutWarning.pIgnoreGroup + ", continuing")		  end if		  		  // What should the Title Be in the Popup Window		  if ( PlistHelper.readPlist(LogoutWarning.pDefaultPrefsFSPath, LogoutWarning.pDefaultPrefsFileName, "WindowTitle", mTempFoundPlistData ) ) then		    		    LogoutWarning.WarningTitle.setString(str(mTempFoundPlistData))		    		    LogToFile(CurrentMethodName + ": Found the default key data, = " + str(mTempFoundPlistData) )		    		  else // Failed!		    		    LogToFile(CurrentMethodName + ": Warning! Failed to find the default key 'WindowTitle', using default of "+ str(LogoutWarning.WarningTitle.Text))		    		  end if		  		  // How long should we wait before considering the Mac is idle too long?		  if ( PlistHelper.readPlist(LogoutWarning.pDefaultPrefsFSPath, LogoutWarning.pDefaultPrefsFileName, "ComputerIdleAfterNumSeconds", mTempFoundPlistData ) ) then		    		    		    LogoutWarning.pComputerIdleAfterNumSeconds = val( mTempFoundPlistData )		    		    LogToFile(CurrentMethodName + ": Found the default key data, = " + str(LogoutWarning.pComputerIdleAfterNumSeconds) )		    		    		  else // Failed!		    		    LogToFile(CurrentMethodName + ": Warning! Failed to find the default key 'ComputerIdleAfterNumSeconds', using default of "+ str (LogoutWarning.pComputerIdleAfterNumSeconds) )		    		  end if		  		  // How often should we check to see how long the Mac has been idle?		  if ( PlistHelper.readPlist(LogoutWarning.pDefaultPrefsFSPath, LogoutWarning.pDefaultPrefsFileName, "IdleLoopDelaySeconds", mTempFoundPlistData ) ) then		    		    LogoutWarning.pIdleLoopDelaySeconds = val( mTempFoundPlistData )		    		    LogToFile(CurrentMethodName + ": Found the default key data, = " + str(LogoutWarning.pIdleLoopDelaySeconds) )		    		  else // Failed!		    		    LogToFile(CurrentMethodName + ": Warning! Failed to find the default key 'IdleLoopDelaySeconds', using default of "+ str (LogoutWarning.pIdleLoopDelaySeconds) )		    		  end if		  		  		  // How long should we wait for the user to respond for More Time or to Log Out?		  if ( PlistHelper.readPlist(LogoutWarning.pDefaultPrefsFSPath, LogoutWarning.pDefaultPrefsFileName, "WaitForUserPromptSeconds", mTempFoundPlistData ) ) then		    		    LogoutWarning.pWaitForUserPromptSeconds = val( mTempFoundPlistData )		    		    LogToFile(CurrentMethodName + ": Found the default key data, = " + str(LogoutWarning.pWaitForUserPromptSeconds) )		    		  else // Failed!		    		    LogToFile(CurrentMethodName + ": Warning! Failed to find the default key 'WaitForUserPromptSeconds', using default of "+ str (LogoutWarning.pWaitForUserPromptSeconds) )		    		  end if		  		  		  		  // Set default		  LogToFile(CurrentMethodName + ": Setting pMoreTimeAskedFor as True")		  Dim pMoreTimeAskedFor as Boolean = true		  // Hide window from view at start		  LogoutWarning.Hide()		  // Start IdleThread		  LogToFile(CurrentMethodName + ": Running IdleThread")		  		  		  // start thread to watch for idle		  StartIdleWatch()		  		  // ShowCountDown()		  // while boolean ready to logout is false		  // when idle time is max		  // display countdown timer		  // 		  		  		  		  		  //LogoutWarning.IdleThread.Run		  		  //LogoutWarning.CountdownThread.Run		  		  		  		  // exit app now		  LogToFile(CurrentMethodName + ": <---")		End Sub	#tag EndEvent	#tag Method, Flags = &h0		Function IdleSeconds() As Integer		  // Set up variables for idle time		  // Shell result		  Dim mIdleSecs As String		  // Shell exit code		  Dim merrCode As  Integer		  // Set up shell		  Dim s As Shell		  s=New Shell		  s.Mode = 0		  		  // Check idle time		  //s.Execute code to check idle time from USB input devices		  s.Execute "/bin/echo $((`/usr/sbin/ioreg -c IOHIDSystem | /usr/bin/sed -e '/HIDIdleTime/ !{ d' -e 't' -e '}' -e 's/.* = //g' -e 'q'` / 1000000000))"		  // Set results to mIdleResult		  mIdleSecs = s.Result		  // Set error code to mIdleError		  merrCode = s.ErrorCode		  // Log mIdleResult for debugging		  // System.Log(System.LogLevelError, "Method: " + midleSecs)		  // LogToFile("mIdleSeconds: " + str(mIdleSecs))		  Return val(mIdleSecs)		End Function	#tag EndMethod	#tag Method, Flags = &h0		Function RemoteControlCheck() As Boolean		  // Set up variables for idle time		  Dim stablished as String = "ESTABLISHED"		  		  // Shell result		  Dim rccheck As String		  // Shell exit code		  Dim merrCode As  Integer		  // Set up shell		  Dim s As Shell		  s=New Shell		  s.Mode = 0		  		  		  // Check idle time		  //s.Execute code to check for connection		  s.Execute "/usr/sbin/netstat -n | /usr/bin/grep '.5900'| /usr/bin/awk '{print $6}'"		  		  // Set results to rccheck		  // Make the entire returned text uppercase in case Apple ever changes the case to CaMeL CaSe, which would break our code:		  rccheck = Uppercase(s.Result)		  		  //Testing line below		  // rccheck ="ESTABLISHED"		  		  //LogToFile("rccheck: " + rccheck)		  // Set error code to merrCode		  merrCode = s.ErrorCode		  		  // LogToFile("rccheck: "+ rccheck)		  // LogToFile("stablished: "+ stablished)		  		  If ( InStr( rccheck, stablished ) > 0 ) then		    return true		  else		    //LogToFile("rccheck: false")		    return false		  End if		  		  // System.Log(System.LogLevelError, "Method: " + midleSecs)		  // LogToFile("mIdleSeconds: " + str(mIdleSecs))		  		  		  		End Function	#tag EndMethod	#tag Method, Flags = &h0		Sub StartIdleWatch()		  if ( pWatchForIdleThread = nil ) then		    		    pWatchForIdleThread = _		    new WatchForIdleThread(Int32(eTaskType.StartIdleWatch ))		    		    AddHandler pWatchForIdleThread.Run, WeakAddressOf Thread_WaitForIdleTime		    AddHandler pWatchForIdleThread.Finished, WeakAddressOf Thread_Finished		    		  end if		  // Run the thread if it's not already running:		  		  if ( pWatchForIdleThread.State <> Thread.Running ) then		    LogoutWarning.Hide()		    pWatchForIdleThread.Run		    		  end if		End Sub	#tag EndMethod	#tag Method, Flags = &h0		Sub StartUserCountDown()		  if ( pIdleCountDownThread = nil ) then		    		    pIdleCountDownThread = _		    new WatchForIdleThread		    		    AddHandler pIdleCountDownThread.Run, WeakAddressOf Thread_WaitForUserInput		    AddHandler pIdleCountDownThread.Finished, WeakAddressOf Thread_Finished		    		  end if		  // Run the thread if it's not already running:		  		  if ( pIdleCountDownThread.State <> Thread.Running ) then		    		    pIdleCountDownThread.Run		    		  end if		End Sub	#tag EndMethod	#tag Method, Flags = &h21		Private Sub Thread_Finished(paramThread as WatchForIdleThread)		  LogToFile(CurrentMethodName + ": --->")		  		  // Kill the thread that was used to get here		  paramThread.Kill		  		  select case int32 ( paramThread.pTaskType )		    		  case int32( eTaskType.StartIdleWatch )		    		    LogToFile(CurrentMethodName + ": Idle time has expired.")		    // Show Login Window		    LogoutWarning.Show()		    // start logout countdown window		    StartUserCountDown()		    		  case int32 ( eTaskType.StartUserCountDown )		    		    LogToFile(CurrentMethodName + ": No user response from countdown.")		    		    if (LogoutWarning.pMoreTimeAskedFor) then		      		      StartIdleWatch()		    else		      // kill user logins		      LogoutWarning.forceLogout		      		    end if		  else		    		  end select		  		End Sub	#tag EndMethod	#tag Method, Flags = &h21		Private Sub Thread_WaitForIdleTime(paramThread as WatchForIdleThread)		  Dim mIdleResult As Integer		  mIdleResult = IdleSeconds()		  LogToFile(CurrentMethodName + " waiting for " + str(LogoutWarning.pComputerIdleAfterNumSeconds))		  while ( mIdleResult < LogoutWarning.pComputerIdleAfterNumSeconds )		    		    // Wait pIdleLoopDelaySeconds:		    App.SleepCurrentThread( LogoutWarning.pIdleLoopDelaySeconds * 1000 )		    		    // Check idle time:		    mIdleResult = IdleSeconds()		    		    LogToFile(CurrentMethodName + ": Idle Seconds: " + str(mIdleResult))		    		  wend		  		  // if there is a ARD/VNC session, don't idle out		  // netstat -n | grep '.5900'		  while (RemoteControlCheck() )		    //LogToFile("rcCheck = true")		    LogToFile(CurrentMethodName + ": Someone is controlling via ARD/VNC, waiting...")		  wend		  //LogToFile("rcCheck = false")		  LogToFile(CurrentMethodName + ": No one is controlling via ARD/VNC, continuing...")		  		  		End Sub	#tag EndMethod	#tag Method, Flags = &h21		Private Sub Thread_WaitForUserInput(paramThread as WatchForIdleThread)		  LogToFile(CurrentMethodName + ": --->")		  		  // Set how long to wait before logging out user, set from global variable for LogOutDelay		  Dim pLogoutDelay as Integer = LogoutWarning.pWaitForUserPromptSeconds		  		  // Stop the idle thread		  		  		  		  // While we're waiting for the countdown to finish...		  LogToFile(CurrentMethodName + "Countdown")		  While pLogoutDelay >= 0		    // Set label to the time left		    LogToFile(CurrentMethodName + "Time Left: " + str(pLogoutDelay))		    // LogoutWarning.TimeLabel.setString(str(pLogoutDelay))		    // Refresh it		    // LogoutWarning.TimeLabel.Refresh		    LogoutWarning.mTimeLabelValue = pLogoutDelay		    // take a second away from the time left		    pLogoutDelay = pLogoutDelay - 1		    // do nothing for 1 second		    		    App.SleepCurrentThread( 1000 ) // sleep 1 second		    		  Wend		  		  // If we're here, the user didn't cancel or log out manaully		  		  // Testing mode, use say instead of logout		  Dim s As Shell		  s=New Shell		  s.Mode = 0		  		  // s.Execute "say Logging Out" // Testing line		  		  LogoutWarning.pMoreTimeAskedFor = false		  		  LogToFile(CurrentMethodName + ": Time Out for Response. Log User Out...")		  		  		  LogToFile(CurrentMethodName + ": <---")		  		  		  //s.Execute "/usr/bin/sudo /Library/CLMshared/psuRebootNow.pl" // Run script to reboot Mac		  //s.Execute "/bin/bash /Library/CLMadmin/psuForceLogOut.sh" // Use this line to test logouts		  LogoutWarning.forceLogout		  		  // Quit app		  Quit		  		End Sub	#tag EndMethod	#tag Note, Name = Icon		Application Icon use with CC license:		From http://www.flickr.com/photos/23453447@N02/5107438855/sizes/o/in/photostream/		By zyrquel		http://www.flickr.com/photos/23453447@N02/	#tag EndNote	#tag Property, Flags = &h0		pAppVersion As String = "1.1"	#tag EndProperty	#tag Property, Flags = &h0		pIdleCountDownThread As WatchForIdleThread	#tag EndProperty	#tag Property, Flags = &h0		pWatchForIdleThread As WatchForIdleThread	#tag EndProperty	#tag Property, Flags = &h0		Untitled As Integer	#tag EndProperty	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"	#tag EndConstant	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"	#tag EndConstant	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"	#tag EndConstant	#tag Enum, Name = eTaskType, Type = Integer, Flags = &h0		StartIdleWatch		StartUserCountDown	#tag EndEnum	#tag ViewBehavior		#tag ViewProperty			Name="pAppVersion"			Group="Behavior"			InitialValue="1.1"			Type="String"			EditorType="MultiLineEditor"		#tag EndViewProperty		#tag ViewProperty			Name="Untitled"			Group="Behavior"			Type="Integer"		#tag EndViewProperty	#tag EndViewBehaviorEnd Class#tag EndClass