extends Node2D

var player_data = null
func _ready():
	pass # Replace with function body.

# select the player
func _on_selected_area_body_entered(body):
	var avatar = body.get_parent()
	player_data = avatar.get_avatar_data()
	Global.select_player(player_data)
	$Form/PlayerName.text=player_data.name


func _on_select_player_btn_pressed():
	Global.load_nw_setup_form( get_parent() )
	self.queue_free()
