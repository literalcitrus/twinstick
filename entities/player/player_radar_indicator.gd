extends Sprite

const radius = 100

var indicating = null
var dir = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	dir = indicating.get_global_pos() - get_parent().get_global_pos()
	set_pos(dir.normalized() * radius)
	set_rot(dir.angle())

func die():
	queue_free()
