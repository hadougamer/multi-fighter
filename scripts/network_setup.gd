extends Node2D

var _nickname = ""
var _ip = ""

func _ready():
	print("[Network_setup] Network setup screen ...")
	
	# Client can inform different ip
	$Form/Fields/IP.text = Network.ip_address
	_ip = $Form/Fields/IP.text

	# Save global var with this form
	Global.form_setup = self

# Input the nickname
func _on_Nickname_text_changed( new_nickname ):
	_nickname = new_nickname

# Press CREATE server button
func _on_Create_server_pressed():
	if _nickname == "":
		return

	Network.create_server( _nickname )

# Press JOIN server button
func _on_Join_server_pressed():
	if _nickname == "":
		return

	Network.join_server( _nickname, _ip)

func wait_show():
	$Wait/Fields/SERV_IP.text = self._ip
	$Wait.show()

func wait_hide():
	$Wait.hide()

func form_hide():
	$Form.hide()
