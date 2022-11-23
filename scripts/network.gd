extends Node

# Constants
const SERVER_PORT = 6969
const MAX_PLAYERS = 10

# Network Inititial Settings
var ip_address 			 = null
var network:NetworkedMultiplayerENet

# Local player infos
var local_info			 = {}
# Connected players info
var players_info		 = {}
# Local
var local_player:KinematicBody2D

var pre_fighter 	= preload("res://scenes/fighter.tscn")

# On Ready
func _ready():	
	print( "# Network manager loaded ... #" )
	
	ip_address = Global.ip_address
	network 	 = NetworkedMultiplayerENet.new()
	
	# Signals and callbacks callings
	get_tree().connect('connected_to_server', 			self, '_server_connected')
	get_tree().connect('network_peer_connected', 		self, '_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')

# Creates a Server
func create_server( nickname ):
	print("[Network] {nickname} creates a server at {ip}".format( {"nickname": nickname, "ip": ip_address} ))
	
	# Validates the settings
	if !ip_address or !network:
		print("[Network Error] Invalid IP Address or Network instance")
		return

	network.create_server(SERVER_PORT, MAX_PLAYERS)	
	get_tree().set_network_peer(network)

	local_info = {
		"name": nickname, 
		"type": "server", 
		"position":Vector2(Global.get_randint(180, 480), 590)
	}

# Joins the Server
func join_server( nickname, ip):
	print("[Network] {nickname} joined to the server: {ip}".format({"nickname": nickname, "ip": ip}))

	# Validates the settings
	if !ip_address or !network:
		print("[Network Error] Invalid IP Address or Network instance")
		return

	network.create_client(ip, SERVER_PORT)
	get_tree().set_network_peer(network)

	local_info = {
		"name": nickname, 
		"type": "client", 
		"position":Vector2(Global.get_randint(180, 480), 590)
	}

# Loads the level
func load_level(num):
	if !Global.stage:
		var root = get_tree().get_root()
		Global.load_stage(root, num);

# Loads the fighter
func load_fighter( player_id, player_data ):
	var fighter = pre_fighter.instance()
	fighter.set_name(str(player_id))
	fighter.set_network_master(player_id)
	fighter.add_to_group("fighters")

	if Global.stage and not Global.stage.has_fighter(str(player_id)):
		fighter.global_position = player_data.position
		fighter.set_fighter_name(player_data.name)
		Global.stage.add_child(fighter)	
		
		return fighter
	
	return false

func load_game_env():
	load_level(0)

### CALLBACKS

# Server connected callback
func _server_connected():
	print("[Network] Server is Connected")

# Player connected callback
func _player_connected( id ):
	# Register players at the loby
	rpc_id(id, "register_player", local_info)

# Player disconnected callback
func _player_disconnected( id ):
	print("[Network] Player {id} is disconnected :(".format({"id":str(id)}) )


### REMOTES
remote func register_player(info):
	# Register the player at the lobby
	var id = get_tree().get_rpc_sender_id()
	print("[Network] Registering player {id}". format({"id":id}))
	players_info[id] = info

	# Load the env (Stage, UI, etc..)
	load_game_env()

	# Loads the local player
	var local_id = get_tree().get_network_unique_id()
	var my_player = load_fighter( local_id, local_info )
	if my_player:
		local_player = my_player

	# Loads the other places
	for player_id in players_info:
		load_fighter( player_id, players_info[player_id] )
