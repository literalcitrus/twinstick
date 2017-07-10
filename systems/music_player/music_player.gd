extends StreamPlayer

var ingame_music = preload("res://music/Reformat.ogg")

func _ready():
	set_stream(ingame_music)
	set_volume_db(-6)
	set_loop(true)
	play()
