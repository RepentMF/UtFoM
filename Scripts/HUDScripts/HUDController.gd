extends Control

#sets various sprites for hud
var fist_texture = load("res://Sprites/HUD/Fist.png")
var knife_texture = load("res://Sprites/HUD/Knife.png")
var hammer_texture = load("res://Sprites/HUD/Hammer.png")
var sword_texture = load("res://Sprites/HUD/Sword.png")
var claw_texture = load("res://Sprites/HUD/Claw.png")
var blade_texture = load("res://Sprites/HUD/Blade.png")


func _physics_process(_delta: float) -> void:
	%HealthBar.value = %StatsController.currentHealth
	#Checks for grandparent variable and loads the appropriate sprite
	match get_parent().get_parent().currentWeapon.name:
		"fists":
			%WeaponIcon.texture = fist_texture
		"knife":
			%WeaponIcon.texture = knife_texture
		"hammer":
			%WeaponIcon.texture = hammer_texture
		"sword":
			%WeaponIcon.texture = sword_texture
		"claw":
			%WeaponIcon.texture = claw_texture
		"blade":
			%WeaponIcon.texture = blade_texture
