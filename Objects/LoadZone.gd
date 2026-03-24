extends Area2D

var areaSceneName
var areaNextSceneName
var loadNext = false

func _ready():
	var index = str(get_tree().current_scene).find(":")
	areaSceneName = str(get_tree().current_scene).left(index)
	areaNextSceneName = get_meta("NextSceneName")

func _physics_process(delta):
	if loadNext:
		get_tree().change_scene_to_file("res://Areas/" + areaNextSceneName + ".tscn")

func _on_body_entered(body):
	if body.name.contains("PlayerCharacter"):
		print("res://Areas/" + areaNextSceneName + ".tscn")
		loadNext = true
		GlobalDataManager.save_player_data(body)
		GlobalDataManager.loadingFromPrev = true
		# Save player data
	pass # Replace with function body.
