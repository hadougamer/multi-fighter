extends Node

# Visual Elements
var pre_ui 			= preload("res://scenes/game_ui.tscn")
var pre_nw_setup 	= preload("res://scenes/network_setup.tscn")
var pre_fireball 	= preload("res://scenes/fireball.tscn")

# Global Inititial Settings
var form_setup 		= null
var stage_name 		= null
var cur_context 	= null
var cur_stage			= null
var total_time 		= 60
var level_time 		= 0
var stage 				= null
var ui 						= null
var ip_address 		= null
var stages = [
	preload("res://scenes/stage-01.tscn")
]

# On Ready
func _ready():	
	print( "# Global settings loaded ... #" )
	ip_address = get_ip_address()

# Loads a stage 
func load_stage(context, num):
	var stage_loaded = get_tree().get_nodes_in_group("stage")
	cur_context = context
	
	if stage_loaded.size() > 0:
		stage_loaded[0].queue_free()

	cur_stage=num 
	stage = stages[num].instance()
	stage.add_to_group("stage")
	context.add_child( stage )

# Loads the network setup form
func load_nw_setup_form( context ):
	var stage_loaded = get_tree().get_nodes_in_group("stage")
	if stage_loaded.size() > 0:
		stage_loaded[0].queue_free()
	
	var nw_setup = pre_nw_setup.instance()
	nw_setup.add_to_group("stage")
	context.add_child( nw_setup )

# Loads the User Interface
func load_ui(context):
	var ui_ref = weakref(ui);
	if ui_ref.get_ref():
		ui.queue_free()

	ui = pre_ui.instance()
	context.add_child(ui)

# Retrieves the IP
func get_ip_address():
	var result_ip = ""
	if OS.get_name() == 'Android':
		result_ip = IP.get_local_addresses()[0]
	else:
		result_ip = IP.get_local_addresses()[3]

	for ip in IP.get_local_addresses():
		if ip.begins_with('192.168.') and not ip.ends_with('.1'):
			result_ip = ip

	return result_ip

# Get Random INT
func get_randint(start:int, end:int):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(start, end)
