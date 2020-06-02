ScriptName NuclearWinter:Gear:Database extends NuclearWinter:Core:Required
{QUST:Winter_Gear}
import NuclearWinter
import NuclearWinter:Context
import Shared:Log
import Shared:Papyrus
import Form

UserLog Log
Entry[] Collection1
Entry[] Collection2
Entry[] Collection3
Entry[] Collection4
Entry[] Collection5
Entry[] Collection6
Entry[] Collection7
Entry[] Collection8
Entry[] Collection9
Entry[] Collection10
int MostRecentCollection
CustomEvent OnRefreshed

string UpdateState = "UpdateState" const

Struct Entry
	int FormID = -1
	Armor Item = none
	int Exposure = 0
EndStruct


; Properties
;---------------------------------------------
Group Context
	Gear:Equipment Property Equipment Auto Const Mandatory
EndGroup

Group Database
	int Property Invalid = -1 AutoReadOnly

	bool Property IsBusy Hidden
		bool Function Get()
			return StateName == UpdateState
		EndFunction
	EndProperty

	int Property Count Hidden
		int Function Get()
			return Collection1.Length + Collection2.Length + Collection3.Length + Collection4.Length + Collection5.Length + Collection6.Length + Collection7.Length + Collection8.Length + Collection9.Length
		EndFunction
	EndProperty
	
	FormList Property Winter_ArmorExposure_0 Auto
	FormList Property Winter_ArmorExposure_5 Auto
	FormList Property Winter_ArmorExposure_10 Auto
	FormList Property Winter_ArmorExposure_15 Auto
	FormList Property Winter_ArmorExposure_20 Auto
	FormList Property Winter_ArmorExposure_25 Auto
	FormList Property Winter_ArmorExposure_30 Auto
	FormList Property Winter_ArmorExposure_35 Auto
	FormList Property Winter_ArmorExposure_40 Auto
	FormList Property Winter_ArmorExposure_45 Auto
	FormList Property Winter_ArmorExposure_50 Auto
	FormList Property Winter_ArmorExposure_55 Auto
	FormList Property Winter_ArmorExposure_60 Auto
	FormList Property Winter_ArmorExposure_65 Auto
	FormList Property Winter_ArmorExposure_70 Auto
	FormList Property Winter_ArmorExposure_75 Auto
	FormList Property Winter_ArmorExposure_80 Auto
	FormList Property Winter_ArmorExposure_85 Auto
	FormList Property Winter_ArmorExposure_90 Auto
	FormList Property Winter_ArmorExposure_95 Auto
	FormList Property Winter_ArmorExposure_100 Auto
	
	FormList Property Winter_ExposureKeywordList Auto
EndGroup


; Events
;---------------------------------------------

Event OnInitialize()
	Log = GetLog(self)
	Log.FileName = "Winter Gear"
	;Collection1 = new Entry[128]
	;Collection2 = new Entry[128]
	;Collection3 = new Entry[128]
	;Collection4 = new Entry[128]
	;Collection5 = new Entry[128]
	;Collection6 = new Entry[128]
	;Collection7 = new Entry[128]
	;Collection8 = new Entry[128]
	;Collection9 = new Entry[128]
	;Collection10 = new Entry[128]
	MostRecentCollection = 1
EndEvent


Event OnEnable()
	ChangeState(self, UpdateState)
	RegisterForRemoteEvent(Player, "OnPlayerLoadGame")
EndEvent


Event OnDisable()
	UnregisterForRemoteEvent(Player, "OnPlayerLoadGame")
EndEvent


Event Actor.OnPlayerLoadGame(Actor akSender)
	ChangeState(self, UpdateState)
EndEvent


; Functions
;---------------------------------------------

int Function Add(Entry current)
	{IGNORE}
	WriteLine(Log, "Ignoring request to add '"+Current.Item.GetName())
	return -1
EndFunction

; Checks an armor for any cooresponding Exposure keywords and adds that exposure if it exists
int Function CheckExposureKeywords(Armor akArmor)
	int i = 0
	While (i < Winter_ExposureKeywordList.GetSize())
		If akArmor.HasKeyword(Winter_ExposureKeywordList.GetAt(i) as Keyword)
			return (i * 5)
		Else
			i += 1
		EndIf
	EndWhile
	return 0
EndFunction

int Function GetExposure(Armor akArmor)
	If akArmor != None
		WriteLine(Log, "		==================GetExposure==================")
		int index = IndexOf(akArmor)
		If (index == Invalid)
			WriteLine(Log, "			" +akArmor.GetName() + ": 0 | Armor not in Collection.")
			int value = 0 
			value = CheckExposureKeywords(akArmor)
			If value > 0
				WriteLine(Log,"			" + akArmor.GetName() + ": " + value)
				WriteLine(Log, "		===============================================")
				return value
			Else
				WriteLine(Log,"			" + akArmor.GetName() + ": 0")
				WriteLine(Log, "		===============================================")
				return 0
			EndIf
		ElseIf (index >= 0 && index < 128)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection1[index].Exposure + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection1[index].Exposure
		ElseIf (index >= 128 && index < 256)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection2[index-128].Exposure + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection2[index-128].Exposure
		ElseIf (index >= 256 && index < 384)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection3[index-256].Exposure + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection3[index-256].Exposure
		ElseIf (index >= 384 && index < 512)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection4[index-384].Exposure + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection4[index-384].Exposure
		ElseIf (index >= 512 && index < 640)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection5[index-512].Exposure + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection5[index-512].Exposure
		ElseIf (index >= 640 && index < 768)
			WriteLine(Log, "			" +akArmor.GetName() + ": " + Collection6[index-640].Exposure + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection6[index-640].Exposure
		ElseIf (index >= 768 && index < 896)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection7[index-768].Exposure + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection7[index-768].Exposure
		ElseIf (index >= 896 && index < 1024)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection8[index-896].Exposure + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection8[index-896].Exposure
		ElseIf (index > 1024 && index < 1152)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection9[index-1024].Exposure + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection9[index-1024].Exposure
		ElseIf (index >= 1152)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection10[index].Exposure + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection10[index-1152].Exposure
		Else
			return 0
		EndIf
	Else
		WriteLine(Log,"			" + akArmor.GetName() + ": 0 | Armor is None.")
		WriteLine(Log, "		===============================================")
		return 0
	EndIf
EndFunction


int Function GetArmorFormID(Armor akArmor)
	If akArmor != None
		WriteLine(Log, "		==================GetArmorFormID==================")
		int index = IndexOf(akArmor)
		If (index == Invalid)
			WriteLine(Log, "			" +akArmor.GetName() + ": 0 | Armor not in Collection.")
			return Invalid
		ElseIf (index >= 0 && index < 128)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection1[index].FormID + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection1[index].FormID
		ElseIf (index >= 128 && index < 256)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection2[index-128].FormID + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection2[index-128].FormID
		ElseIf (index >= 256 && index < 384)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection3[index-256].FormID + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection3[index-256].FormID
		ElseIf (index >= 384 && index < 512)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection4[index-384].FormID + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection4[index-384].FormID
		ElseIf (index >= 512 && index < 640)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection5[index-512].FormID + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection5[index-512].FormID
		ElseIf (index >= 640 && index < 768)
			WriteLine(Log, "			" +akArmor.GetName() + ": " + Collection6[index-640].FormID + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection6[index-640].FormID
		ElseIf (index >= 768 && index < 896)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection7[index-768].FormID + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection7[index-768].FormID
		ElseIf (index >= 896 && index < 1024)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection8[index-896].FormID + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection8[index-896].FormID
		ElseIf (index > 1024 && index < 1152)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection9[index-1024].FormID + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection9[index-1024].FormID
		ElseIf (index >= 1152)
			WriteLine(Log,"			" + akArmor.GetName() + ": " + Collection10[index].FormID + " | Index: " + index)
			WriteLine(Log, "		===============================================")
			return Collection10[index-1152].FormID
		Else
			return Invalid
		EndIf
	Else
		WriteLine(Log,"			" + akArmor.GetName() + ": 0 | Armor is None.")
		WriteLine(Log, "		===============================================")
		return Invalid
	EndIf
EndFunction


bool Function Contains(Armor akArmor)
	If akArmor != None
		int i = 0
		while i < Collection1.Length
			if Collection1[i] == none
				i += 1
			elseif Collection1[i].Item == akArmor
				return true
			else
				i += 1
			endif
		endWhile
		
		i = 0
		while i < Collection2.Length
			if Collection2[i] == none
				i += 1
			elseif Collection2[i].Item == akArmor
				return true
			else
				i += 1
			endif
		endWhile
		
		i = 0
		while i < Collection3.Length
			if Collection3[i] == none
				i += 1
			elseif Collection3[i].Item == akArmor
				return true
			else
				i += 1
			endif
		endWhile
		
		i = 0
		while i < Collection4.Length
			if Collection4[i] == none
				i += 1
			elseif Collection4[i].Item == akArmor
				return true
			else
				i += 1
			endif
		endWhile
		
		i = 0
		while i < Collection5.Length
			if Collection5[i] == none
				i += 1
			elseif Collection5[i].Item == akArmor
				return true
			else
				i += 1
			endif
		endWhile
		
		i = 0
		while i < Collection6.Length
			if Collection6[i] == none
				i += 1
			elseif Collection6[i].Item == akArmor
				return true
			else
				i += 1
			endif
		endWhile
		
		i = 0
		while i < Collection7.Length
			if Collection7[i] == none
				i += 1
			elseif Collection7[i].Item == akArmor
				return true
			else
				i += 1
			endif
		endWhile
		
		i = 0
		while i < Collection8.Length
			if Collection8[i] == none
				i += 1
			elseif Collection8[i].Item == akArmor
				return true
			else
				i += 1
			endif
		endWhile
		
		i = 0
		while i < Collection9.Length
			if Collection9[i] == none
				i += 1
			elseif Collection9[i].Item == akArmor
				return true
			else
				i += 1
			endif
		endWhile
		
		i = 0
		while i < Collection10.Length
			if Collection10[i] == none
				i += 1
			elseif Collection10[i].Item == akArmor
				return true
			else
				i += 1
			endif
		endWhile
		return false
	Else
		return false
	EndIf

EndFunction


int Function IndexOf(Armor akArmor)
	If akArmor != None
		If (Collection1.FindStruct("Item", akArmor) >= 0)
			return Collection1.FindStruct("Item", akArmor)
		ElseIf (Collection2.FindStruct("Item", akArmor) >= 0)
			return Collection2.FindStruct("Item", akArmor) + 128
		ElseIf (Collection3.FindStruct("Item", akArmor) >= 0)
			return Collection3.FindStruct("Item", akArmor) + 256
		ElseIf (Collection4.FindStruct("Item", akArmor) >= 0)
			return Collection4.FindStruct("Item", akArmor) + 384
		ElseIf (Collection5.FindStruct("Item", akArmor) >= 0)
			return Collection5.FindStruct("Item", akArmor) + 512
		ElseIf (Collection6.FindStruct("Item", akArmor) >= 0)
			return Collection6.FindStruct("Item", akArmor) + 640
		ElseIf (Collection7.FindStruct("Item", akArmor) >= 0)
			return Collection7.FindStruct("Item", akArmor) + 768
		ElseIf (Collection8.FindStruct("Item", akArmor) >= 0)
			return Collection8.FindStruct("Item", akArmor) + 896
		ElseIf (Collection9.FindStruct("Item", akArmor) >= 0)
			return Collection9.FindStruct("Item", akArmor) + 1024
		ElseIf (Collection10.FindStruct("Item", akArmor) >= 0)
			return Collection10.FindStruct("Item", akArmor) + 1152
		Else
			return Invalid
		EndIf
	Else
		return Invalid
	EndIf
EndFunction


Armor Function GetAt(int aindex)
	If (aindex >= 0 && aindex < 128)
		return Collection1[aindex].Item
	ElseIf (aindex >= 128 && aindex < 256)
		return Collection2[aindex - 128].Item
	ElseIf (aindex >= 256 && aindex < 384)
		return Collection3[aindex - 256].Item
	ElseIf (aindex >= 384 && aindex < 512)
		return Collection4[aindex - 384].Item
	ElseIf (aindex >= 512 && aindex < 640)
		return Collection5[aindex - 512].Item
	ElseIf (aindex >= 640 && aindex < 768)
		return Collection6[aindex - 640].Item
	ElseIf (aindex >= 768 && aindex < 896)
		return Collection7[aindex - 768].Item
	ElseIf (aindex >= 896 && aindex < 1024)
		return Collection8[aindex - 896].Item
	ElseIf (aindex >= 1024 && aindex < 1152)
		return Collection9[aindex - 1024].Item
	ElseIf (aindex >= 1152)
		return Collection10[aindex - 1152].Item
	Else
		return none
	EndIf
EndFunction


string Function EntryToString(Entry current) Global
	If (current)
		If (current.Item)
			return current.Item.GetName()+":"+current.Item
		Else
			return current.Item.GetName()+":"+current.FormID
		EndIf
	Else
		return "Invalid Entry"
	EndIf
EndFunction

Function AddArmor(Armor Item, Int Exposure)
	Entry NewEntry = new Entry
	NewEntry.FormID = Item.GetFormID()
	NewEntry.Item = Item
	NewEntry.Exposure = Exposure
	MostRecentCollection = Add(NewEntry)
EndFunction



; Methods
;---------------------------------------------

State UpdateState
	
	int Function Add(Entry current)
		If (current)
			;If (Contains(current.Item) == false)
				int i = 0
				If MostRecentCollection == 1
					while i < Collection1.Length
						if Collection1[i] == none
							Collection1[i] = current
							WriteLine(Log, "Added the entry '"+EntryToString(current)+"'" + " to Collection1." + " | Exposure: " + Collection1[i].Exposure + " | Index: " + i)
							return 1
						else
							i += 1
						endif
					endWhile
					MostRecentCollection = 2
				EndIf
				
				If MostRecentCollection == 2
					i = 0
					while i < Collection2.Length
						if Collection2[i] == none
							Collection2[i] = current
							WriteLine(Log, "Added the entry '"+EntryToString(current)+"'" + " to Collection2." + " | Exposure: " + Collection2[i].Exposure + " | Index: " + (i + 128))
							return 2
						else
							i += 1
						endif
					endWhile
					MostRecentCollection = 3
				EndIf
				
				If MostRecentCollection == 3
					i = 0
					while i < Collection3.Length
						if Collection3[i] == none
							Collection3[i] = current
							WriteLine(Log, "Added the entry '"+EntryToString(current)+"'" + " to Collection3." + " | Exposure: " + current.Exposure + " | Index: " + (i + 256))
							return 3
						else
							i += 1
						endif
					endWhile
					MostRecentCollection = 4
				EndIf
				
				If MostRecentCollection == 4
					i = 0
					while i < Collection4.Length
						if Collection4[i] == none
							Collection4[i] = current
							WriteLine(Log, "Added the entry '"+EntryToString(current)+"'" + " to Collection4." + " | Exposure: " + current.Exposure + " | Index: " + (i + 384))
							return 4
						else
							i += 1
						endif
					endWhile
					MostRecentCollection = 5
				EndIf
				
				If MostRecentCollection == 5
					i = 0
					while i < Collection5.Length
						if Collection5[i] == none
							Collection5[i] = current
							WriteLine(Log, "Added the entry '"+EntryToString(current)+"'" + " to Collection5." + " | Exposure: " + current.Exposure + " | Index: " + (i + 512))
							return 5
						else
							i += 1
						endif
					endWhile
					MostRecentCollection = 6
				EndIf
				
				If MostRecentCollection == 6
					i = 0
					while i < Collection6.Length
						if Collection6[i] == none
							Collection6[i] = current
							WriteLine(Log, "Added the entry '"+EntryToString(current)+"'" + " to Collection6." + " | Exposure: " + current.Exposure + " | Index: " + (i + 640))
							return 6
						else
							i += 1
						endif
					endWhile
					MostRecentCollection = 7
				EndIf
				
				If MostRecentCollection == 7
					i = 0
					while i < Collection7.Length
						if Collection7[i] == none
							Collection7[i] = current
							WriteLine(Log, "Added the entry '"+EntryToString(current)+"'" + " to Collection7." + " | Exposure: " + current.Exposure + " | Index: " + (i + 768))
							return 7
						else
							i += 1
						endif
					endWhile
					MostRecentCollection = 8
				EndIf
				
				If MostRecentCollection == 8
					i = 0
					while i < Collection8.Length
						if Collection8[i] == none
							Collection8[i] = current
							WriteLine(Log, "Added the entry '"+EntryToString(current)+"'" + " to Collection8." + " | Exposure: " + current.Exposure + " | Index: " + (i + 896))
							return 8
						else
							i += 1
						endif
					endWhile
					MostRecentCollection = 9
				EndIf
				
				If MostRecentCollection == 9
					i = 0
					while i < Collection9.Length
						if Collection9[i] == none
							Collection9[i] = current
							WriteLine(Log, "Added the entry '"+EntryToString(current)+"'" + " to Collection9." + " | Exposure: " + current.Exposure + " | Index: " + (i + 1024))
							return 9
						else
							i += 1
						endif
					endWhile
					MostRecentCollection = 10
				EndIf
				
				If MostRecentCollection == 10
					i = 0
					while i < Collection10.Length
						if Collection10[i] == none
							Collection10[i] = current
							WriteLine(Log, "Added the entry '"+EntryToString(current)+"'" + " to Collection10." + " | Exposure: " + current.Exposure + " | Index: " + (i + 1152))
							return 10
						else
							i += 1
						endif
					endWhile
				EndIf
				WriteLine(Log, "Error: Too many entries, discarding '"+EntryToString(current)+"' from Total Collection.")
				return -1
			;Else
				;WriteLine(Log, "Collection already contains the entry '"+EntryToString(current)+"'.")
				;return -1
			;EndIf
		Else
			WriteLine(Log, "The current entry cannot be none.")
			return -1
		EndIf
	EndFunction


	Event OnEndState(string asNewState)
		WriteLine(Log, "Sending the OnRefreshed event for collection..")
		SendCustomEvent("OnRefreshed")
	EndEvent


	Event OnBeginState(string asOldState)
		Collection1 = new Entry[128]
		Collection2 = new Entry[128]
		Collection3 = new Entry[128]
		Collection4 = new Entry[128]
		Collection5 = new Entry[128]
		Collection6 = new Entry[128]
		Collection7 = new Entry[128]
		Collection8 = new Entry[128]
		Collection9 = new Entry[128]
		Collection10 = new Entry[128]
		MostRecentCollection = 1
		WriteLine(Log, "=============Beginning Database Initialization===============")
		WriteLine(Log, "=============================================================")
		int i = 0
		;Debug.Notification("Adding 0 Exposure Armors")
		While(i < Winter_ArmorExposure_0.GetSize())
			If(Winter_ArmorExposure_0.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_0.GetAt(i) as Armor, 0)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 5 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_5.GetSize())
			If(Winter_ArmorExposure_5.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_5.GetAt(i) as Armor, 5)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 10 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_10.GetSize())
			If(Winter_ArmorExposure_10.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_10.GetAt(i) as Armor, 10)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 15 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_15.GetSize())
			If(Winter_ArmorExposure_15.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_15.GetAt(i) as Armor, 15)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 20 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_20.GetSize())
			If(Winter_ArmorExposure_20.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_20.GetAt(i) as Armor, 20)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 25 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_25.GetSize())
			If(Winter_ArmorExposure_25.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_25.GetAt(i) as Armor, 25)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 30 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_30.GetSize())
			If(Winter_ArmorExposure_30.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_30.GetAt(i) as Armor, 30)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 35 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_35.GetSize())
			If(Winter_ArmorExposure_35.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_35.GetAt(i) as Armor, 35)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 40 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_40.GetSize())
			If(Winter_ArmorExposure_40.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_40.GetAt(i) as Armor, 40)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 45 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_45.GetSize())
			If(Winter_ArmorExposure_45.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_45.GetAt(i) as Armor, 45)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 50 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_50.GetSize())
			If(Winter_ArmorExposure_50.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_50.GetAt(i) as Armor, 50)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 55 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_55.GetSize())
			If(Winter_ArmorExposure_55.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_55.GetAt(i) as Armor, 55)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 60 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_60.GetSize())
			If(Winter_ArmorExposure_60.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_60.GetAt(i) as Armor, 60)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 65 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_65.GetSize())
			If(Winter_ArmorExposure_65.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_65.GetAt(i) as Armor, 65)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 70 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_70.GetSize())
			If(Winter_ArmorExposure_70.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_70.GetAt(i) as Armor, 70)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 75 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_75.GetSize())
			If(Winter_ArmorExposure_75.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_75.GetAt(i) as Armor, 75)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 80 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_80.GetSize())
			If(Winter_ArmorExposure_80.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_80.GetAt(i) as Armor, 80)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 85 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_85.GetSize())
			If(Winter_ArmorExposure_85.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_85.GetAt(i) as Armor, 85)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 90 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_90.GetSize())
			If(Winter_ArmorExposure_90.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_90.GetAt(i) as Armor, 90)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 95 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_95.GetSize())
			If(Winter_ArmorExposure_95.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_95.GetAt(i) as Armor, 95)
			EndIf
			i = i+1
		EndWhile
		;Debug.Notification("Adding 100 Exposure Armors")
		i = 0
		While(i < Winter_ArmorExposure_100.GetSize())
			If(Winter_ArmorExposure_100.GetAt(i) != None)
				AddArmor(Winter_ArmorExposure_100.GetAt(i) as Armor, 100)
			EndIf
			i = i+1
		EndWhile
		WriteLine(Log, "==============Finished Database Initialization===============")
		WriteLine(Log, "=============================================================")
		WriteLine(Log, " ")
		Debug.Notification("Collection Finished Initializing")
		Equipment.UpdateExposure()
		
		ChangeState(self, EmptyState)
	EndEvent
EndState
