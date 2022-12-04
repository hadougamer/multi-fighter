extends Node2D

var start_position = null
var can_tween = true
var pre_avatar = preload("res://scenes/player_select_avatar.tscn")
var avatars_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = $player_list.global_position
	self.get_avatars()
	var avatar_canva_width = 200
	
	var i = 0
	for avatar_item in avatars_list:
		var avatar = pre_avatar.instance()
		avatar.set_avatar_data(avatar_item)
		avatar.name = "player-{id}".format({"id": avatar_item.id})
		avatar.get_node("avatar_rect").color = get_rand_color()
		avatar.global_position = Vector2((avatar_canva_width*i), 8)
		avatar.get_node("sprite").texture=load(
			"res://avatars/{avt_image}".format({"avt_image": avatar_item.avatar})
		)
		$player_list.add_child(avatar)
		i+=1

func _process(delta):
	if Input.is_action_just_pressed("ui_right") and can_tween:
		if $player_list.global_position.x > -1*(((avatars_list.size()-3)*200)-22):
			$Tween.interpolate_property(
				$player_list, 
				"global_position", 
				Vector2($player_list.global_position.x, $player_list.global_position.y),
				Vector2(($player_list.global_position.x-200), $player_list.global_position.y), 
				0.2, 
				Tween.TRANS_LINEAR, 
				Tween.EASE_IN_OUT
			)
			can_tween=false
		
	elif Input.is_action_just_pressed("ui_left") and can_tween:
		if $player_list.global_position.x < start_position.x + 400:
			$Tween.interpolate_property(
				$player_list, 
				"global_position", 
				Vector2($player_list.global_position.x, $player_list.global_position.y),
				Vector2(($player_list.global_position.x+200), $player_list.global_position.y), 
				0.2, 
				Tween.TRANS_LINEAR, 
				Tween.EASE_IN_OUT
			)
			
		can_tween=false
	
	
	$Tween.start()

func get_avatars():
	avatars_list = Global.load_players()

func get_rand_color():
	var r = Global.get_randint(1, 100) * 0.01
	var g = Global.get_randint(1, 100) * 0.01
	var b = Global.get_randint(1, 100) * 0.01
	
	return Color(r, g, b, 1)


func _on_Tween_tween_all_completed():
	can_tween=true
