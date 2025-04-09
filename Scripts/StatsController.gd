extends Node2D

var health
var mana
var stamina

var healthChange
var healthTimer
var healthFreq
var manaChange
var manaTimer
var manaFreq
var staminaChange
var staminaTimer
var staminaFreq

func _ready():
	health = get_parent().get_meta("Health")
	mana = get_parent().get_meta("Mana")
	stamina = get_parent().get_meta("Stamina")

func _physics_process(_delta):
	if healthTimer > 0:
		if healthTimer % healthFreq == 0:
			modify_current_stat("health", healthChange, 0, 0)

func modify_current_stat(stat, change, freq, timer):
	if stat == "health":
		health = health + change
		if timer > 0:
			healthChange = change
			healthTimer = timer
			healthFreq = freq
	elif stat == "mana":
		mana = mana + change
		if timer > 0:
			manaChange = change
			manaTimer = timer
			manaFreq = freq
	elif stat == "stamina":
		stamina = stamina + change
		if timer > 0:
			staminaChange = change
			staminaTimer = timer
			staminaFreq = freq
	#apply every frequency of time until timer is 0
