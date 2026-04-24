extends Camera2D

var targetPlayer

func _ready():
	targetPlayer = get_tree().current_scene.get_node("PlayerCharacter")

func _physics_process(delta):
	position = targetPlayer.position
	pass
