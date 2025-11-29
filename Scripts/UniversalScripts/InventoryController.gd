extends Node

var inventory = []
var currentWeapon

func _ready():
	#There needs to be a reason/rationale for replacing empty inputs with something else
	inventory.push_back(new_weapon_add("fists", "put 'em up", "HeavyPunch", "HeavyPunch", "HeavyPunch")) # heavy, no looping
	inventory.push_back(new_weapon_add("knife", "it's a knife", "LightKnife", "LightKnife", "LightKnife")) # light, no looping
	inventory.push_back(new_weapon_add("hammer", "hammer c:", "JuggleHammer", "HeavyHammer", "JuggleHammer")) # juggle 1 > juggle 2 > juggle 3 > heavy; juggle 1 > juggle 2 > heavy; juggle 1 > heavy; heavy
	inventory.push_back(new_weapon_add("sword", "swoosh", "LightSword", "HeavySword", "LightSword")) # light 1 > light 2 > heavy; light 1 > heavy; heavy
	inventory.push_back(new_weapon_add("claw", "santa", "LightClaw", "LightClaw", "LightClaw")) # light, no looping
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
