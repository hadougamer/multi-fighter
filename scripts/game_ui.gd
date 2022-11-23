extends CanvasLayer

var level_time  = 1 * Global.total_time
var _min_str=null

func _process(delta):
	if Global.stage_name:
		$"control/stage_name".text = Global.stage_name

	# Clock
	var _min = 0
	var _sec = 0
	if level_time > 0:
		level_time -= (1 * delta)
		_min = int(level_time/60)
		_sec = int(((level_time/60) - _min) * 60)
	else:
		get_tree().call_group("hero", "time_kill")

	$"control/time_counter".text = "{min}:{sec}".format({"min": ("%02d" % _min),"sec": ("%02d" % _sec) })
