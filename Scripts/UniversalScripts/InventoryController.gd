extends Node

var keyItemsInventory = []
var weaponsInventory = []
var currentWeapon

func _ready():
	weaponsInventory.push_back(new_weapon_add("fists", "put 'em up", "HeavyPunch", "HeavyPunch", "HeavyPunch")) # heavy, no looping
	#weaponsInventory.push_back(new_weapon_add("knife", "it's a knife", "LightKnife", "LightKnife", "LightKnife")) # light, no looping
	#weaponsInventory.push_back(new_weapon_add("hammer", "hammer c:", "JuggleHammer", "HeavyHammer", "JuggleHammer")) # juggle 1 > juggle 2 > juggle 3 > heavy; juggle 1 > juggle 2 > heavy; juggle 1 > heavy; heavy
	#weaponsInventory.push_back(new_weapon_add("sword", "swoosh", "LightSword", "HeavySword", "LightSword")) # light 1 > light 2 > heavy; light 1 > heavy; heavy
	#weaponsInventory.push_back(new_weapon_add("gauntlet", "beeg fists", "LightGauntlet", "HeavyGauntlet", "LightGauntlet"))
	#weaponsInventory.push_back(new_weapon_add("claw", "santa", "LightClaw", "LightClaw", "LightClaw")) # light, no looping
	#weaponsInventory.push_back(new_weapon_add("blade", "swish", "LightBlade", "JuggleBlade", "JuggleBlade")) # light 1 > light 2 > juggle; light 1 > juggle; juggle
	
	currentWeapon = weaponsInventory[0]

func new_key_item_add(iName, description):
	var NewKeyItem = load("res://Scripts/UniversalScripts/KeyItem.gd")
	var key_instantiator = NewKeyItem.new()
	key_instantiator.name = iName
	key_instantiator.iName = iName
	key_instantiator.description = description
	return key_instantiator

func new_weapon_add(iName, description, light, heavy, juggle):
	var NewWep = load("res://Scripts/UniversalScripts/Weapon.gd")
	var wep_instantiator = NewWep.new()
	wep_instantiator.name = iName
	wep_instantiator.description = description
	wep_instantiator.light = light
	wep_instantiator.heavy = heavy
	wep_instantiator.juggle = juggle
	return wep_instantiator
