extends Area2D
 
export(int) var distance = 1000.0
export(int) var damage = 1
export(int) var movement_speed = 2000

var direction = Vector2()
var target_group = ""

func _ready():
	set_fixed_process(true)
	set_rot(direction.angle())
	var ttd = 1/(movement_speed / distance)
	get_node("Timer").set_wait_time(ttd)
	get_node("Timer").start()

func _fixed_process(delta):
	set_pos(get_pos() + direction * movement_speed * delta)

func _on_Bullet_body_enter( body ):
	if (body.is_in_group(target_group)):
		print("Hit enemy")
		queue_free()
 
func _on_Timer_timeout():
	queue_free()