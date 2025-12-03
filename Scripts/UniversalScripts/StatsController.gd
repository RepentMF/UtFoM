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

# Modify corresponding current stat and return calculated stat
func modify_stat(curStat, change, maxStat):
	var calculatedStat = curStat + change
	#var stack_trace = get_stack()
	#for item in stack_trace:
	#	print(item)
	return check_min_max(calculatedStat, maxStat)

# Check if calculated stat will be changed to be greater than max stat or 
# negative
func check_stat_overage(curStat, change, maxStat, zeroStat):
	if zeroStat:
		if curStat + change >= 0:
			return true
		else:
			return false
	else:
		if curStat + change <= maxStat:
			return true
		else:
			return false

# Return calculated stat (change current stat if it is greater than max stat or
# negative
func check_min_max(minStat, maxStat):
	if minStat <= 0:
		minStat = 0
	elif minStat >= maxStat:
		minStat = maxStat
	return minStat
