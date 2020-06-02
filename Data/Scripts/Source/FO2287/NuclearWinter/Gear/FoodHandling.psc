Scriptname NuclearWinter:Gear:FoodHandling extends NuclearWinter:Core:Optional
{QUST:Winter_Gear}
import NuclearWinter
import NuclearWinter:World
import Shared:Log

UserLog Log

Spell FoodHeatExpiration
int RegisterTimer = 0

bool first = true
bool ConsumedCold = false

Event OnInitialize()
	Log = new UserLog
	Log.Caller = self
	Log.FileName = "Winter_Food"
	SpellsToIgnore = new Int[Winter_WarmFoodSpells.GetSize()]
EndEvent

Event OnEnable()
	WriteLine(Log, "FoodHandling: Enable " + FoodToggle)
	If FoodToggle
		SpellsToIgnore = new Int[Winter_WarmFoodSpells.GetSize()]
		AddInventoryEventFilter(Winter_WarmFoods)
		AddInventoryEventFilter(Winter_ColdFoods)
		RegisterForRemoteEvent(Player, "OnItemAdded")
		RegisterForRemoteEvent(Player, "OnItemRemoved")
		RegisterForRemoteEvent(Player, "OnItemEquipped")
		int i = 0
		While i < Winter_WarmFoods.GetSize()
			int j = 0
			While j < Player.GetItemCount(Winter_WarmFoods.GetAt(i))
				(Winter_WarmFoodSpells.GetAt(i) as Spell).Cast(Player, Player)
				j += 1
			EndWhile
			i += 1
		EndWhile
	EndIf
EndEvent

Event OnDisable()
	RemoveAllInventoryEventFilters()
	UnRegisterForRemoteEvent(Player, "OnItemAdded")
	UnRegisterForRemoteEvent(Player, "OnItemRemoved")
	UnRegisterForRemoteEvent(Player, "OnItemEquipped")
EndEvent

Event ObjectReference.OnItemAdded(ObjectReference akObjRef, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	If (akBaseItem != None)
		If Winter_WarmFoods.HasForm(akBaseItem)
			WriteLine(Log, "FoodHandling: Adding Spell Food | aiItemCount: " + aiItemCount)
			int i = 0
			While i < aiItemCount
					(Winter_WarmFoodSpells.GetAt(Winter_WarmFoods.Find(akBaseItem)) as Spell).Cast(Player, Player)
					i += 1
					;Utility.Wait(0.2)
			EndWhile
			If first
				int button = Winter_FoodHelp.Show()
				If button == 1
					first = false
				EndIf
			EndIf
		EndIf
	EndIf
EndEvent

Event ObjectReference.OnItemRemoved(ObjectReference akObjRef, Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	Utility.Wait(0.1)
	If (akBaseItem != None)
		If Winter_WarmFoods.HasForm(akBaseItem)
			If (akDestContainer != None) && (akDestContainer != Player)
				WriteLine(Log, "FoodHandling: Removing + aiItemCount + Warm Food into a container, turn into cold")
				akDestContainer.RemoveItem(akBaseItem,aiItemCount)
				akDestContainer.AddItem(Winter_ColdFoods.GetAt(Winter_WarmFoods.Find(akBaseItem)), aiItemCount, true)
				SpellsToIgnore[Winter_WarmFoods.Find(akBaseItem)] += aiItemCount
			ElseIf akItemReference != None
				WriteLine(Log, "FoodHandling: Removing " + aiItemCount + " Warm Food into world, turn into cold and delete original reference")
				akItemReference.Delete()
				Player.AddItem(Winter_ColdFoods.GetAt(Winter_WarmFoods.Find(akBaseItem)), aiItemCount, true)
				Player.DropObject(Winter_ColdFoods.GetAt(Winter_WarmFoods.Find(akBaseItem)), aiItemCount)
				SpellsToIgnore[Winter_WarmFoods.Find(akBaseItem)] += aiItemCount
			EndIf
		EndIf
	EndIf
EndEvent

Event Actor.OnItemEquipped(Actor akActor, Form akBaseObject, ObjectReference akReference)
	If akBaseObject != None
	  UnRegisterForRemoteEvent(Player, "OnItemRemoved")
	  If Winter_WarmFoods.HasForm(akBaseObject)
		If ConsumedCold == false
			WriteLine(Log, "FoodHandling: Warm Food Consumed, add heating spell")
			Winter_FoodWarming.Cast(Player,Player)
			Player.EquipItem(Winter_WarmFood_Description,false,true)
		EndIf
		ConsumedCold = false
	  ElseIf Winter_ColdFoods.HasForm(akBaseObject)
		ConsumedCold = true
		WriteLine(Log, "FoodHandling: Cold Food Consumed, add food spell")
		UnRegisterForRemoteEvent(Player, "OnItemAdded")
		Player.AddItem(Winter_WarmFoods.GetAt(Winter_ColdFoods.Find(akBaseObject)), 1, true)
		Player.EquipItem(Winter_WarmFoods.GetAt(Winter_ColdFoods.Find(akBaseObject)),false, true)
		RegisterForRemoteEvent(Player, "OnItemAdded")
	  EndIf
	  RegisterForRemoteEvent(Player, "OnItemRemoved")
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

Group Properties
	GlobalVariable Property Winter_FoodToggle Auto
	int[] Property SpellsToIgnore Auto
	Spell Property Winter_FoodWarming Auto
	FormList Property Winter_ColdFoods Auto
	FormList Property Winter_WarmFoods Auto
	FormList Property Winter_WarmFoodSpells Auto
	Message Property Winter_FoodHelp Auto
	Potion Property Winter_WarmFood_Description Auto
	
	bool Property FoodToggle
		bool Function Get()
			return (Winter_FoodToggle.GetValueInt() as bool)
		EndFunction
		Function Set(bool value)
			Winter_FoodToggle.SetValueInt(value as Int)
			If value == true
				SpellsToIgnore = new Int[Winter_WarmFoodSpells.GetSize()]
				AddInventoryEventFilter(Winter_WarmFoods)
				AddInventoryEventFilter(Winter_ColdFoods)
				RegisterForRemoteEvent(Player, "OnItemAdded")
				RegisterForRemoteEvent(Player, "OnItemRemoved")
				RegisterForRemoteEvent(Player, "OnItemEquipped")
				int i = 0
				While i < Winter_WarmFoods.GetSize()
					int j = 0
					While j < Game.GetPlayer().GetItemCount(Winter_WarmFoods.GetAt(i))
						(Winter_WarmFoodSpells.GetAt(i) as Spell).Cast(Player, Player)
						j += 1
					EndWhile
					i += 1
				EndWhile
			Else
				RemoveAllInventoryEventFilters()
				UnRegisterForRemoteEvent(Player, "OnItemAdded")
				UnRegisterForRemoteEvent(Player, "OnItemRemoved")
				UnRegisterForRemoteEvent(Player, "OnItemEquipped")
				int i = 0
				While i < Winter_ColdFoods.GetSize()
					Player.AddItem(Winter_WarmFoods.GetAt(i), Player.GetItemCount(Winter_ColdFoods.GetAt(i)), true)
					Player.RemoveItem(Winter_ColdFoods.GetAt(i), Player.GetItemCount(Winter_ColdFoods.GetAt(i)))
					i += 1
				EndWhile
			EndIf
		EndFunction 
	EndProperty

EndGroup
