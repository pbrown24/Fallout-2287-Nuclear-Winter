Scriptname NuclearWinter:Gear:MaskWipe extends NuclearWinter:Core:Optional
{MGEF:NuclearWinter_Gear}
import NuclearWinter
import NuclearWinter:Player:Animation
import Shared:Log

UserLog Log


int RainStartTimer = 0
int RainLoopTimer = 1
int RainEndTimer = 2
Data Current

; Events
;---------------------------------------------

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Mask Wipe"
EndEvent


Event OnEnable()
	WriteLine(Log, "Mask Wipe Intialized.")
	RegisterForRemoteEvent(Player, "OnItemEquipped")
	RegisterForCustomEvent(Mask, "OnChanged")
	RegisterForCustomEvent(Climate, "OnWeatherChanged")
	RegisterForCustomEvent(Climate, "OnLocationChanged")
	RegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
	RegisterForCustomEvent(DetectInteriors, "OnExitInterior")
	Current = new Data
EndEvent


Event OnDisable()
	UnregisterForRemoteEvent(Player, "OnItemEquipped")
	UnregisterForCustomEvent(Mask, "OnChanged")
	UnRegisterForCustomEvent(Climate, "OnWeatherChanged")
	UnRegisterForCustomEvent(Climate, "OnLocationChanged")
	UnRegisterForCustomEvent(DetectInteriors, "OnEnterInterior")
	UnRegisterForCustomEvent(DetectInteriors, "OnExitInterior")
	EndAll(false)
EndEvent

Struct Data
	bool RainEndLoop = false
	bool Raining = false
EndStruct


; Methods
;---------------------------------------------

State ActiveState
	Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
		int iCount = Player.GetItemCount(NuclearWinter_GearWipe)
		Player.RemoveItem(NuclearWinter_GearWipe, iCount, abSilent = true)

		If (Mask.IsGasMask)
			WriteLine(Log, "Gas Mask Equipped...")
			Player.AddItem(NuclearWinter_GearWipe, 1, abSilent = true)
			WriteLine(Log, "Added the mask wipe item.")
			If Current.RainEndLoop
				StartTimer(0.1, RainEndTimer)
			EndIf
			Evaluate()
		;Add conditions here as you add more visual effects | This removes them if they are currently active and a mask is removed
		Else
			WriteLine(Log, "Gas Mask Removed...")
			If(Current.RainEndLoop)
				NuclearWinter_GearWipeVFX_RainEndLoop.Stop(Player)
			EndIf
			Evaluate()
		EndIf
	EndEvent
	
	Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Weather Changed...")
		Evaluate()
	EndEvent
	
	Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
		WriteLine(Log, "Changed Location...")
		Utility.wait(2.0)
		If Player.IsInInterior()
			MaskOverlay.Remove()
			MaskOverlay.Apply()
			WriteLine(Log, "Entered Interior...")
			Evaluate()
		Else
			Evaluate()
		EndIf	
	EndEvent
	
	Event NuclearWinter:Gear:DetectInteriors.OnEnterInterior(Gear:DetectInteriors akSender, var[] arguments)
		Evaluate()
	EndEvent
	
	Event NuclearWinter:Gear:DetectInteriors.OnExitInterior(Gear:DetectInteriors akSender, var[] arguments)
		Evaluate()
	EndEvent
	
	Event OnTimer(int aiTimerID)
		; Start Rain
		If aiTimerID == RainStartTimer
			Current.Raining = true
			CancelTimer(RainLoopTimer)
			CancelTimer(RainEndTimer)
			NuclearWinter_GearWipeVFX_RainEnd.Stop(Player)
			NuclearWinter_GearWipeVFX_RainLoop.Stop(Player)
			NuclearWinter_GearWipeVFX_RainStart.Stop(Player)
			NuclearWinter_GearWipeVFX_RainStart.Play(Player,RainDuration_Start)
			WriteLine(Log, "Start RainVFX.")
			StartTimer(RainDuration_Start - Rain_Start_Overlap, RainLoopTimer)
		EndIf
		; Loop Rain
		If aiTimerID == RainLoopTimer
			NuclearWinter_GearWipeVFX_RainLoop.Stop(Player)
			NuclearWinter_GearWipeVFX_RainLoop.Play(Player,RainDuration_Loop)
			WriteLine(Log, "Loop RainVFX.")
			StartTimer(RainDuration_Loop - Rain_Loop_Overlap, RainLoopTimer)
		EndIf
		; After Ending, Play static Rain End Loop
		If aiTimerID == RainEndTimer
			If Mask.IsGasMask
				NuclearWinter_GearWipeVFX_RainEndLoop.Stop(Player)
				NuclearWinter_GearWipeVFX_RainEndLoop.Play(Player)
				Current.RainEndLoop = true
				WriteLine(Log, "EndLoop RainVFX.")
				StartTimer(60.0, RainEndTimer)
			EndIf
		EndIf
	EndEvent

	Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
		If (akBaseObject == NuclearWinter_GearWipe)
			If (Utility.IsInMenuMode())
				NuclearWinter_GearExitPipboyMessage.Show()
			EndIf
			If (Player.GetItemCount(NuclearWinter_GearWipe) == 0)
				Player.AddItem(NuclearWinter_GearWipe, 1, abSilent = true)
				WriteLine(Log, "Refunding the mask wipe item.")
			EndIf
			
			If(Mask.FormID == 0x001184C1)
				If(IsFirstPerson)
					IdlePlay(Player, MaskWipeIdleFP, Log)
				Else
					IdlePlay(Player, MaskWipeIdleTP, Log)
				EndIf
			ElseIf(Mask.FormID == 0x00007A77)
				If(IsFirstPerson)
					IdlePlay(Player, M1A211_1stPUseMaskWipeOnSelf, Log)
				Else
					IdlePlay(Player, M1A211_3rdPUseMaskWipeOnSelf, Log)
				EndIf
			ElseIf(Mask.FormID == 0x000787D8)
				If(IsFirstPerson)
					IdlePlay(Player, SingleVisor_1stPUseMaskWipeOnSelf, Log)
				Else
					IdlePlay(Player, SingleVisor_3rdPUseMaskWipeOnSelf, Log)
				EndIf
			Else
				If(IsFirstPerson)
					IdlePlay(Player, MaskWipeIdleFP, Log)
				Else
					IdlePlay(Player, MaskWipeIdleTP, Log)
				EndIf
			EndIf
			NuclearWinter_GearWipeSFX.Play(Player)
			
			WriteLine(Log, "HandRefrac VFX.")
			If (Climate.Classification == 2.0 && Current.Raining)
				EndRain(false, true)
			ElseIf (Climate.Classification == 3.0)
				;Place Holder
			EndIf
			If(Current.RainEndLoop)
				NuclearWinter_GearWipeVFX_RainEndLoop.Stop(Player)
				Current.RainEndLoop = false
			EndIf
		EndIf	
		
	EndEvent
EndState


Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	{EMPTY}
EndEvent

Event Actor.OnItemEquipped(Actor akSender, Form akBaseObject, ObjectReference akReference)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnLocationChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:World:Climate.OnWeatherChanged(World:Climate akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:DetectInteriors.OnEnterInterior(Gear:DetectInteriors akSender, var[] arguments)
	{EMPTY}
EndEvent

Event NuclearWinter:Gear:DetectInteriors.OnExitInterior(Gear:DetectInteriors akSender, var[] arguments)
	{EMPTY}
EndEvent
;Function
;---------------------------------------------

Function Evaluate()
	WriteLine(Log, "Evaluating...")
	If Mask.IsGasMask
		If Player.IsInInterior() == false
			If(DetectInteriors.IsInFakeInterior == false)
				WriteLine(Log, "Evaluation | Climate:" + Climate.Classification + " | Raining? " + Current.Raining)
				; It started raining, begin VFX
				If (Climate.Classification == 2.0 && Current.Raining == false)
					WriteLine(Log, "Started Raining, start VFX")
					Current.Raining = true
					StartTimer(Rain_Restart, RainStartTimer)
				; It is no longer raining, start ending VFX
				ElseIf(Climate.Classification != 2.0 && Current.Raining)
					WriteLine(Log, "Stopped Raining, ending VFX")
					Current.Raining = false
					EndRain(true, false)
				EndIf
			Else
				If Current.Raining
					WriteLine(Log, "Fake Interior, End VFX | Climate: " + Climate.Classification + " | isRaining: " + Current.Raining)
					EndAll(false)
					StartTimer(0.1, RainEndTimer)
					Current.Raining = false
				EndIf
			EndIf
		Else
			If Current.Raining
				WriteLine(Log, "Interior, End VFX | Climate: " + Climate.Classification + " | isRaining: " + Current.Raining)
				EndAll(false)
				StartTimer(0.1, RainEndTimer)
				Current.Raining = false
			EndIf
		EndIf
	Else
		If Current.Raining
			WriteLine(Log, "No Mask, End VFX | Climate: " + Climate.Classification + " | isRaining: " + Current.Raining)
			EndAll(false)
			Current.Raining = false
		EndIf
	EndIf
	
EndFunction

Function EndRain(bool PlayRainEnd, bool DoEval)
	WriteLine(Log, "EndRain: Ending Rain." + PlayRainEnd)
	Current.Raining = false
	CancelTimer(RainLoopTimer)
	CancelTimer(RainStartTimer)
	CancelTimer(RainEndTimer)
	NuclearWinter_GearWipeVFX_RainLoop.Stop(Player)
	NuclearWinter_GearWipeVFX_RainStart.Stop(Player)
	NuclearWinter_GearWipeVFX_RainEnd.Stop(Player)
	If PlayRainEnd
		NuclearWinter_GearWipeVFX_RainEnd.Play(Player,RainDuration_End)
		WriteLine(Log, "End RainVFX.")
		StartTimer(RainDuration_End - Rain_End_Overlap, RainEndTimer)
	EndIf
	If DoEval
		Utility.Wait(2.0)
		Evaluate()
	EndIf
EndFunction

Function EndAll(bool DoEval)
	WriteLine(Log, "EndAll VFX...")
	If(Current.Raining)
		If DoEval
			WriteLine(Log, "Then re-evaluate Rain VFX")
			EndRain(false, true)
		Else
			EndRain(false, false)
		EndIf
	EndIf
EndFunction

; Properties
;---------------------------------------------

Group Context
	Gear:DetectInteriors Property DetectInteriors Auto Const Mandatory
	Gear:Mask Property Mask Auto Const Mandatory
	Gear:MaskOverlay Property MaskOverlay Auto Const Mandatory
	World:Climate Property Climate Auto Const Mandatory 
EndGroup

Group Properties
	Potion Property NuclearWinter_GearWipe Auto Const Mandatory
	Sound Property NuclearWinter_GearWipeSFX Auto Const Mandatory
	Message Property NuclearWinter_GearExitPipboyMessage Auto Const Mandatory
	Idle property MaskWipeIdleFP Auto Const Mandatory
	Idle property MaskWipeIdleTP Auto Const Mandatory
	Idle property M1A211_1stPUseMaskWipeOnSelf Auto Const Mandatory
	Idle property M1A211_3rdPUseMaskWipeOnSelf Auto Const Mandatory
	Idle property SingleVisor_1stPUseMaskWipeOnSelf Auto Const Mandatory
	Idle property SingleVisor_3rdPUseMaskWipeOnSelf Auto Const Mandatory
	VisualEffect property HandRefraction Auto Const Mandatory
	Int property HandRefractionDuration Auto Const Mandatory
	{Duration of Hand Refraction Effect}
EndGroup

Group Rain
	VisualEffect property NuclearWinter_GearWipeVFX_RainStart Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_RainLoop Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_RainEnd Auto Const Mandatory
	VisualEffect property NuclearWinter_GearWipeVFX_RainEndLoop Auto Const Mandatory
	
	Int property RainDuration_Start Auto
	{Duration of Rain start.}
	Int property RainDuration_Loop Auto
	{Duration of the Rain loop.}
	Int property RainDuration_End Auto
	{Duration after Rain Weather for Rain effect to end.}
	Int property Rain_Start_Overlap Auto
	{RainDuration_Start - Overlap}
	Int property Rain_Loop_Overlap Auto
	{RainDuration_Loop - Overlap}
	Int property Rain_End_Overlap Auto
	{RainDuration_End - Overlap}
	Int property Rain_Restart Auto
	{Duration before rain effect restarts after being wiped away}
EndGroup


Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup

Bool Property Raining Hidden
		Bool Function Get()
			return Current.Raining
		EndFunction
		Function Set(Bool value)
			Current.Raining = value
		EndFunction
EndProperty

Bool Property EndRainLoop Hidden
		Bool Function Get()
			return Current.RainEndLoop
		EndFunction
		Function Set(Bool value)
			Current.RainEndLoop = value
		EndFunction
EndProperty

