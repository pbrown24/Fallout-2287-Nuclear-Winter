Scriptname NuclearWinter:Gear:ConsumeColdPotion extends ActiveMagicEffect 

Event OnEffectStart(Actor akTarget, Actor akCaster)
	Game.GetPlayer().EquipItem(OriginalPotion, false, true)
EndEvent

Potion Property OriginalPotion Auto
