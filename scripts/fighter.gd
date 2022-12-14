extends KinematicBody2D

export(String) var fighter_name="My Fighter"
const SPEED       = 25
const GRAVITY     = 2
const UP          = Vector2(0,-1)
const JUMP_HEIGHT = 65

var motion    = Vector2()
var animation = "idle"
var flip 	  = false
var life	  = 100
var debug     = false

# Remote/Puppet variables
puppet var p_animation = animation
puppet var p_flip 		 = flip
puppet var p_position  = Vector2(100, 100)
puppet var p_life = 100

func _ready():
	print(
		"Fighter {name}, master: {master} Loaded!".format(
			{
				"name" : fighter_name, 
				"master": is_network_master()
			}
		)
	)

func _physics_process(delta):
	$label.text = fighter_name
	$lifebar.set_value(life)
	
	var gravity = (GRAVITY*delta*500)
	var speed   = (SPEED*delta*500)
	var jump_h  = (JUMP_HEIGHT*delta*500)
			
	if life > 0:
		# Controls the Main Player on his own screen	
		if is_network_master() or debug:
			motion.y += gravity
			if Input.is_action_pressed("ui_right"):
				motion.x = speed
				animation = "walk"
				flip = false
			elif Input.is_action_pressed("ui_left"):
				motion.x = -speed
				animation = "walk"
				flip = true
			else:
				motion.x = 0
				animation = "idle"

			if Input.is_action_just_pressed("ui_shot"):			
				shot()
				rpc('r_shot')
				
			$sprite.play(animation)
			$sprite.flip_h=flip
				
			if is_on_floor():
				if Input.is_action_pressed("ui_jump"):
					motion.y -= jump_h
				
			motion = move_and_slide(motion, UP)

			# Set the remote (puppet) variables
			rset("p_animation", animation)
			rset("p_flip", flip)
			rset_unreliable("p_position", self.global_position)
			rset_unreliable("p_life", life)
		else:
			# Controls the Main Player on other screens
			$sprite.play(p_animation)
			$sprite.flip_h = p_flip
			$lifebar.set_value(p_life)
			self.global_position = p_position
	else:
		# I am a ghost now		
		ghosting(speed)
		Network.kill(name)
		
# Fighter Label Name
func set_fighter_name( name ):
	self.fighter_name = str(name)

# Object Name (id on the network)
func set_name( name ):
	self.name = str(name)

# trigger the shot on puppet
remote func r_shot():
	shot()

# fighter was hitted
func hitted(damage):
	life -= damage

# Fighter turned a ghost
func ghosting(speed):
	# Visibility
	$lifebar.modulate.a8=0	
	$label.modulate.a8=0
	if is_network_master():
		$sprite.modulate.a8=50
	else:
		$sprite.modulate.a8=0

	# Collision
	$collider.disabled=true

	# Movement
	if Input.is_action_pressed("ui_right"):
		motion.x = speed
		animation = "walk"
		flip = false
	elif Input.is_action_pressed("ui_left"):
		motion.x = -speed
		animation = "walk"
		flip = true
	elif Input.is_action_pressed("ui_up"):
		motion.y = -speed
		animation = "walk"
	elif Input.is_action_pressed("ui_down"):
		motion.y = +speed
		animation = "walk"
	else:
		motion.x = 0
		motion.y = 0
		animation = "idle"

	$sprite.play(animation)
	$sprite.flip_h=flip
	motion = move_and_slide(motion, UP)

# trigger the shot
func shot():
	var b_group = "bullets-{name}".format({"name":name})
	# Limits the max amount of bullets
	if get_tree().get_nodes_in_group(b_group).size() < 20:
		var bullet = Global.pre_fireball.instance()
		var b_margin = 35

		bullet.add_to_group(b_group)
		get_parent().add_child(bullet)
		
		bullet.global_position = global_position
		bullet.flipped = $sprite.flip_h
		if $sprite.flip_h:
			bullet.global_position.x -= b_margin
		else:
			bullet.global_position.x += b_margin

func set_skin( skin_name ):	
	var skin_path = "res://sprites/{skin}.png".format(
		{ "skin" : skin_name }
	)
	for animation in $sprite.frames.animations:
		for frame in animation.frames:
			frame.set_atlas(load(skin_path))
