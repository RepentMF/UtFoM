extends Node

var inventory = []
var currentWeapon

func _ready():
	inventory.push_front(new_weapon_add("knife", "it's a knife", "LightKnife", "", ""))
	inventory.push_front(new_weapon_add("hammer", "hammer c:", "LightHammer", "HeavyHammer", "JuggleHammer"))
	inventory.push_front(new_weapon_add("sword", "swoosh", "LightSword", "HeavySword", ""))
	currentWeapon = inventory[1]

func new_weapon_add(iName, description, light, heavy, juggle):
	var NewWep = load("res://Scripts/UniversalScripts/Weapon.gd")
	var wep_instantiator = NewWep.new()
	wep_instantiator.name = iName
	wep_instantiator.description = description
	wep_instantiator.light = light
	wep_instantiator.heavy = heavy
	wep_instantiator.juggle = juggle
	return wep_instantiator
