extends Node2D

export(int) var total_time=100
export(String) var stage_name="1-1"

func _ready():
	Global.stage_name=stage_name
	Global.total_time=total_time
	Global.load_ui(self)

func has_fighter( name ):
	for _child in get_children():
		if _child.is_in_group("fighters"):
			if str(_child.name) == str(name):
				return true

	return false

func _process(_delta):
	if Network.local_player_is_alive():
		# Camera position
		$cam.position = Network.local_player.position

