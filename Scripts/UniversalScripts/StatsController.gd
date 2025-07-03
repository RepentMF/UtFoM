extends Node2D

var maxHealth
var maxMana
var maxStamina
var currentHealth
var currentMana
var currentStamina

func _ready():
	maxHealth = get_parent().get_meta("MaxHealth")
	maxMana = get_parent().get_meta("MaxMana")
	maxStamina = get_parent().get_meta("MaxStamina")
	currentHealth = get_parent().get_meta("Health")
	currentMana = get_parent().get_meta("Mana")
	currentStamina = get_parent().get_meta("Stamina")

func modify_stat(minStat, change, maxStat):
	minStat = minStat + change
	return check_stat(minStat, maxStat)

func check_stat(minStat, maxStat):
	if minStat < 0:
		minStat = 0
	elif minStat > maxStat:
		minStat = maxStat
	return minStat
