extends AnimationTree

@onready var actor = get_owner()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	set("parameters/player_" + actor.temp + "_tree/blend_position", actor.lastDirection)
	match actor.currentState:
		actor.state.idle:
			self["parameters/playback"].travel("player_idle_tree")
			set("parameters/player_idle_tree/blend_position", actor.lastDirection)
		actor.state.walk:
			self["parameters/playback"].travel("player_walk_tree")
		actor.state.run:
			self["parameters/playback"].travel("player_run_tree")
		actor.state.jump:
			self["parameters/playback"].travel("player_jump_tree")
			set("parameters/player_jump_tree/blend_position", actor.lastDirection)
		actor.state.hop:
			self["parameters/playback"].travel("player_hop_tree")
			set("parameters/player_hop_tree/blend_position", actor.lastDirection)
	#run, roll, dash, jump, light_attack, heavy_attack, juggle_attack, push, hitstun, juggle, burst
	pass
