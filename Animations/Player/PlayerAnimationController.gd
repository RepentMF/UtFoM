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
		actor.state.walk:
			self["parameters/playback"].travel("player_walk_tree")
		actor.state.run:
			self["parameters/playback"].travel("player_run_tree")
	#run, roll, dash, jump, light_attack, heavy_attack, juggle_attack, push, hitstun, juggle, burst
	pass
