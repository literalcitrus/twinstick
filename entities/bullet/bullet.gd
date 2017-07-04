extends Area2D

const movement_speed = 2000
const ttd = 0.5
const damage = 1

var direction = Vector2()

func _ready():
	set_fixed_process(true)
	set_rot(direction.angle())
	get_node("Timer").set_wait_time(ttd)
	get_node("Timer").start()

func _fixed_process(delta):
	set_pos(get_pos() + direction * movement_speed * delta)

func _on_Bullet_body_enter( body ):
	if (body.is_in_group("arena")):
		queue_free()
	
	if (body.is_in_group("enemy")):
		body.take_damage(damage)
		queue_free()

func _on_Timer_timeout():
	queue_free()
