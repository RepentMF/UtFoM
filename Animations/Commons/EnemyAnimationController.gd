extends AnimationTree

@onready var actor = get_owner()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	match actor.currentState:
		actor.state.idle:
			set("parameters/" + actor.enemyName + "_idle_tree/blend_position", actor.lastDirection)
			self["parameters/playback"].travel(actor.enemyName + "_idle_tree")
		actor.state.walk:
			set("parameters/" + actor.enemyName + "_idle_tree/blend_position", actor.lastDirection)
			self["parameters/playback"].travel(actor.enemyName + "_idle_tree")
		actor.state.heavy_attack:
			set("parameters/" + actor.enemyName + "_heavy_attack_tree/blend_position", actor.lastDirection)
			self["parameters/playback"].travel(actor.enemyName + "_heavy_attack_tree")
		actor.state.hitstun:
			set("parameters/" + actor.enemyName + "_hitstun_tree/blend_position", actor.lastDirection)
			self["parameters/playback"].travel(actor.enemyName + "_hitstun_tree")
		actor.state.juggle:
			set("parameters/" + actor.enemyName + "_juggle_tree/blend_position", actor.lastDirection)
			self["parameters/playback"].travel(actor.enemyName + "_juggle_tree")
		actor.state.lag:
			set("parameters/" + actor.enemyName + "_lag_tree/blend_position", actor.lastDirection)
			self["parameters/playback"].travel(actor.enemyName + "_lag_tree")
	#run, roll, dash, jump, light_attack, heavy_attack, juggle_attack, push, hitstun, juggle, burst
	pass
