ScriptName NuclearWinter:Terminals:ToggleFoodSystem extends NuclearWinter:Core:Required
import Shared:Log
import NuclearWinter
import NuclearWinter:World

UserLog Log

Event OnInit()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = Context.Title
EndEvent

Function SetFoodActivation()
	If FoodHandling.FoodToggle == false
		FoodHandling.FoodToggle = true
		BeverageHandling.FoodToggle = true
		WriteLine(Log, "Attempting to start the 'Food and Beverage System' context.")
	ElseIf FoodHandling.FoodToggle == true
		FoodHandling.FoodToggle = false
		BeverageHandling.FoodToggle = false
		WriteLine(Log, "Attempting to shutdown the 'Food and Beverage System'.")
	EndIf
EndFunction

Gear:FoodHandling Property FoodHandling Auto Const
Gear:BeverageHandling Property BeverageHandling Auto Const
