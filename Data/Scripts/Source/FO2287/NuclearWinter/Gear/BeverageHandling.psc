Scriptname NuclearWinter:Gear:BeverageHandling extends NuclearWinter:Core:Optional
{QUST:Winter_Gear}
import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

int RegisterTimer = 0
int MeltTimer = 1
bool SpellsApplied = false
bool first = true

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Beverages"
	SpellsToIgnore = new Int[Winter_BeverageSpells.GetSize()]
EndEvent

Event OnEnable()
	If FoodToggle
		FoodHandling.FoodToggle = true
		SpellsToIgnore = new Int[Winter_BeverageSpells.GetSize()]
		AddInventoryEventFilter(Winter_Beverages)
		RegisterForCustomEvent(Thermodynamics, "OnChanged")
		RegisterForRemoteEvent(Player, "OnItemAdded")
		RegisterForRemoteEvent(Player, "OnItemRemoved")
		RegisterForRemoteEvent(Player, "OnItemEquipped")
	EndIf
EndEvent

Event OnDisable()
	CancelTimerGameTime(MeltTimer)
	CancelTimer(RegisterTimer)
	RemoveAllInventoryEventFilters()
	UnRegisterForCustomEvent(Thermodynamics, "OnChanged")
	UnRegisterForRemoteEvent(Player, "OnItemAdded")
	UnRegisterForRemoteEvent(Player, "OnItemRemoved")
	UnRegisterForRemoteEvent(Player, "OnItemEquipped")
	FoodHandling.FoodToggle = false
EndEvent

Event OnTimerGameTime(int aiTimerID)
	If aiTimerID == MeltTimer
		int i = 0
		While i < Winter_Beverages.GetSize()
			If Player.GetItemCount(Winter_FrozenBeverages.GetAt(i)) > 0
				int ItemCount = Player.GetItemCount(Winter_FrozenBeverages.GetAt(i))
				Player.RemoveItem(Winter_FrozenBeverages.GetAt(i),ItemCount, true)
				Player.AddItem(Winter_Beverages.GetAt(i), ItemCount, true)
			EndIf
			i += 1
		EndWhile
		WriteLine(Log, "BeverageHandling: Water melted")
	EndIf
EndEvent

Event NuclearWinter:World:Thermodynamics.OnChanged(World:Thermodynamics akSender, var[] arguments)
	If Thermodynamics.Temperature < 32 && SpellsApplied == False
		CancelTimerGameTime(MeltTimer)
		SpellsApplied = true
		int i = 0
		While i < Winter_Beverages.GetSize()
			int j = 0
			While j < Player.GetItemCount(Winter_Beverages.GetAt(i))
				(Winter_BeverageSpells.GetAt(i) as Spell).Cast(Player, Player)
				j += 1
			EndWhile
			i += 1
		EndWhile
		WriteLine(Log, "BeverageHandling: Stopped melting water")
	ElseIf Thermodynamics.Temperature >= 32 && SpellsApplied
		SpellsApplied = false
		int i = 0
		While i < Winter_BeverageSpells.GetSize()
			Player.DispelSpell((Winter_BeverageSpells.GetAt(i) as Spell))
			Player.DispelSpell((Winter_BeverageSpells.GetAt(i) as Spell))
			i += 1
		EndWhile
		StartTimerGameTime(0.5,MeltTimer)
		WriteLine(Log, "BeverageHandling: Started melting water")
	EndIf
EndEvent

Event ObjectReference.OnItemAdded(ObjectReference akObjRef, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	WriteLine(Log, "BeverageHandling: Adding Spell Food | aiItemCount: " + aiItemCount)
	If Thermodynamics.Temperature < 32
		int i = 0
		While i < aiItemCount
				(Winter_BeverageSpells.GetAt(Winter_Beverages.Find(akBaseItem)) as Spell).Cast(Player, Player)
				i += 1
				;Utility.Wait(0.2)
		EndWhile
		If i > 0
			SpellsApplied = true
		Endif
	EndIf
	If first
		int button = Winter_BeverageHelp.Show()
		If button == 1
			first = false
		EndIf
	EndIf
EndEvent

Event ObjectReference.OnItemRemoved(ObjectReference akObjRef, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	If (akBaseItem != None)
		If Winter_Beverages.HasForm(akBaseItem)
			If Thermodynamics.Temperature < 32 && (Thermodynamics.HeatSource.IsInHeatSource == false)
				If (akDestContainer != None) && (akDestContainer != Player)
					WriteLine(Log, "BeverageHandling: Removing " + aiItemCount + " Beverages into a container, turn into cold")
					akDestContainer.RemoveItem(akBaseItem,aiItemCount)
					akDestContainer.AddItem(Winter_FrozenBeverages.GetAt(Winter_Beverages.Find(akBaseItem)), aiItemCount, true)
					SpellsToIgnore[Winter_Beverages.Find(akBaseItem)] += aiItemCount
				ElseIf akItemReference != None
					WriteLine(Log, "BeverageHandling: Removing " + aiItemCount + " Beverages into world, turn into cold and delete original reference")
					akItemReference.Delete()
					Player.AddItem(Winter_FrozenBeverages.GetAt(Winter_Beverages.Find(akBaseItem)), aiItemCount, true)
					Player.DropObject(Winter_FrozenBeverages.GetAt(Winter_Beverages.Find(akBaseItem)), aiItemCount)
					SpellsToIgnore[Winter_Beverages.Find(akBaseItem)] += aiItemCount
				EndIf
			EndIf
		EndIf
	EndIf
EndEvent

Event Actor.OnItemEquipped(Actor akActor, Form akBaseObject, ObjectReference akReference)
	Utility.Wait(0.1)
	If akBaseObject != None
	  If Winter_FrozenBeverages.HasForm(akBaseObject)
		Player.AddItem(akBaseObject, 1, true)
		Winter_FrozenBeverageMSG.Show()
	  ElseIf Winter_Alcohol.HasForm(akBaseObject)
		WriteLine(Log, "BeverageHandling: Alcohol Consumed, add heating spell")
		Winter_BeverageWarming.Cast(Player,Player)
		Player.EquipItem(Winter_WarmAlcohol_Description,false,true)
	  EndIf
	EndIf
endEvent

Event OnTimer(int aiTimerID)
	If aiTimerID == RegisterTimer
		RegisterForRemoteEvent(Player, "OnItemRemoved")
	EndIf
EndEvent

; We need these for the script FoodExpire to turn Off/On registration when we remove foods so that it doesn't spawn food at our feet.
Function UnRegisterForRemoved()
	UnRegisterForRemoteEvent(Player, "OnItemRemoved")
EndFunction

Function RegisterForRemoved()
	StartTimer(2,RegisterTimer)
EndFunction

Function ResetHelpers()
	first = true
EndFunction

Group Context
	World:Thermodynamics Property Thermodynamics Auto Const Mandatory
EndGroup

Group Properties
	Gear:FoodHandling Property FoodHandling Auto Const
	GlobalVariable Property Winter_FoodToggle Auto
	int[] Property SpellsToIgnore Auto
	Spell Property Winter_BeverageWarming Auto
	FormList Property Winter_Alcohol Auto
	FormList Property Winter_FrozenBeverages Auto
	FormList Property Winter_Beverages Auto
	FormList Property Winter_BeverageSpells Auto
	Message Property Winter_FrozenBeverageMSG Auto
	Message Property Winter_BeverageHelp Auto
	Potion Property Winter_WarmAlcohol_Description Auto
	
	bool Property FoodToggle
		bool Function Get()
			return (Winter_FoodToggle.GetValueInt() as bool)
		EndFunction
		Function Set(bool value)
			If value == true
				SpellsToIgnore = new Int[Winter_BeverageSpells.GetSize()]
				AddInventoryEventFilter(Winter_Beverages)
				RegisterForRemoteEvent(Player, "OnItemAdded")
				RegisterForRemoteEvent(Player, "OnItemRemoved")
				RegisterForRemoteEvent(Player, "OnItemEquipped")
			Else
				CancelTimerGameTime(MeltTimer)
				CancelTimer(RegisterTimer)
				RemoveAllInventoryEventFilters()
				UnRegisterForRemoteEvent(Player, "OnItemAdded")
				UnRegisterForRemoteEvent(Player, "OnItemRemoved")
				UnRegisterForRemoteEvent(Player, "OnItemEquipped")
				int i = 0
				While i < Winter_FrozenBeverages.GetSize()
					Player.AddItem(Winter_Beverages.GetAt(i), Player.GetItemCount(Winter_FrozenBeverages.GetAt(i)), true)
					Player.RemoveItem(Winter_FrozenBeverages.GetAt(i), Player.GetItemCount(Winter_FrozenBeverages.GetAt(i)))
					i += 1
				EndWhile
			EndIf
		EndFunction 
	EndProperty
EndGroup
