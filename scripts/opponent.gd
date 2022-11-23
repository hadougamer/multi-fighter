extends KinematicBody2D

var _id = ""
export(String) var opponent_name="My Opponent"

remote func set_opponent_name( name ):
	self.opponent_name = name

# Animation controls (puppet vars)
puppet var p_animation = "idle"
puppet var p_flip 		 = true
puppet var p_position  = Vector2(100, 100)

func set_id(id):
  _id = id

func _physics_process(_delta):
  $sprite.flip_h  = p_flip
  $sprite.play(p_animation)
  global_position = p_position
