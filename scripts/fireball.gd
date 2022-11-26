extends KinematicBody2D

const SPEED = 300
var flipped = false

func _ready():
	pass
	
func _physics_process(delta):
	var speed   	= (SPEED*delta)
	$sprite.flip_h  = flipped
	
	if flipped:
		global_position.x -= speed
	else:
		global_position.x += speed

func _on_notifier_screen_exited():
	queue_free()

func _bullet_hitted( player ):
	print("Bullet hitted player {name}".format({"name":player.name}))
	player.hitted(5)
	queue_free()

func _on_hit_area_body_entered(body):
	if body.is_in_group("fighters"):
		_bullet_hitted( body )
