Scriptname NuclearWinter:Player:Amnesia extends ActiveMagicEffect 

import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

int TeleportTimer = 0
int BlinkTimer = 2
float scale

Activator Property Winter_Marker Auto
Spell Property Winter_SlowTime Auto
Spell Property Winter_FallImmunity Auto
ImageSpaceModifier property Winter_BlinkImod Auto
GlobalVariable Property GameHour Auto
ObjectReference Marker
Actor Player 

Event OnInIt()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Freezing"
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Player = Game.GetPlayer()
	StartTimer(2,BlinkTimer)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	CancelTimer(BlinkTimer)
	CancelTimer(TeleportTimer)
	If(Marker)
		Marker.Deletewhenable()
        Marker = None
	EndIf
	Player.DispelSpell(Winter_SlowTime)
EndEvent

Event OnTimer(int aiTimerID)

	If aiTimerID == BlinkTimer
		Winter_BlinkImod.Apply(1.0)
		StartTimer(3, TeleportTimer)
	EndIf
	
	If aiTimerID == TeleportTimer
		Marker = Player.PlaceAtMe(Winter_Marker as Form, 1)
		Winter_FallImmunity.Cast(Player,Player)
		int direction = Utility.RandomInt(0,3)
		If direction == 0
			Player.MoveTo(Marker as ObjectReference, Utility.RandomFloat(8000.0, 30000.0), Utility.RandomFloat(8000.0, 30000.0), 0, true)
		ElseIf direction == 1
			Player.MoveTo(Marker as ObjectReference, Utility.RandomFloat(-8000.0, -30000.0), Utility.RandomFloat(8000.0, 30000.0), 0, true)
		ElseIf direction == 2
			Player.MoveTo(Marker as ObjectReference, Utility.RandomFloat(-8000.0, -30000.0), Utility.RandomFloat(-8000.0, -30000.0), 0, true)
		ElseIf direction == 3
			Player.MoveTo(Marker as ObjectReference, Utility.RandomFloat(8000.0, 30000.0), Utility.RandomFloat(-8000.0, -30000.0), 0, true)
		EndIf
		Utility.wait(0.1)
		GameHour.SetValue(Utility.RandomInt(0,24))
		Marker.Deletewhenable()
        Marker = None
		Winter_SlowTime.Cast(Player,Player)
		StartTimer(500,BlinkTimer)
	EndIf
	
EndEvent
