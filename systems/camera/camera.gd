extends Camera2D

var track_node = null

func _ready():
	make_current()
	set_zoom(Vector2(2, 2))
	set_process(true)


func _process(delta):
	if (track_node):
		set_global_pos(track_node.get_global_pos())