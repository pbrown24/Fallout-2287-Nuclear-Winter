ScriptName NuclearWinter:Voice:PlayerVoice extends NuclearWinter:Core:Required
import User:DefaultObject
import NuclearWinter
import Shared:Log

UserLog Log

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "PlayerVoice"
EndEvent

Event OnEnable()
	RegisterForCustomEvent(Mask, "OnChanged")
EndEvent


Event OnDisable()
	UnregisterForCustomEvent(Mask, "OnChanged")
EndEvent

Event NuclearWinter:Gear:Mask.OnChanged(Gear:Mask akSender, var[] arguments)
	WriteLine(Log, "PlayerVoice: Mask.OnChanged")
	If (Mask.IsGasMask && Mask.IsPowerArmor == false)
		Player1stVoiceOutputModel_DO.Set(GasMask_SOMDialoguePlayer2D)
		Player3rdVoiceOutputModel_DO.Set(GasMask_SOMDialoguePlayer3D)
	Else
		Player1stVoiceOutputModel_DO.Set(SOMDialoguePlayer2D)
		Player3rdVoiceOutputModel_DO.Set(SOMDialoguePlayer3D)
	EndIf
EndEvent

;Properties ----------------------------------------
Group Properties
	Gear:Mask Property Mask Auto Const Mandatory
	Form Property Player1stVoiceOutputModel_DO Auto Mandatory
	Form Property Player3rdVoiceOutputModel_DO Auto Mandatory
	Form Property GasMask_SOMDialoguePlayer2D Auto Const Mandatory
	Form Property GasMask_SOMDialoguePlayer3D Auto Const Mandatory
	Form Property SOMDialoguePlayer2D Auto Const Mandatory
	Form Property SOMDialoguePlayer3D Auto Const Mandatory
EndGroup
