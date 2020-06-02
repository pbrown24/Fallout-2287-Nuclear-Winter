ScriptName NuclearWinter:ContextActivation extends NuclearWinter:Core:Required
import Shared:Log
import NuclearWinter
import NuclearWinter:Context

UserLog Log

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent

Function SetActivation()
	If Context.IsActivated == false
		;If Winter_Context.IsRunning() == False
			;Winter_Context.Start()
			;WriteLine(Log, "Winter_Context not running, attempting to start")
		;Else
			Context.IsActivated = true
		;EndIf
		WriteLine(Log, "Attempting to start the '"+Context.Title+"' context.")
	ElseIf Context.IsActivated == true
		Context.IsActivated = false
		WriteLine(Log, "Attempting to shutdown the '"+Context.Title+"' context.")
	EndIf
EndFunction

Quest Property Winter_Context Auto Const Mandatory