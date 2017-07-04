extends KinematicBody2D

const movement_speed = 300
const points = 50

signal died()

var movement_dir = Vector2()
var health_points = 1
var rot_speed = 135
var collision_buffer = false

func _ready():
	set_fixed_process(true)
	movement_dir = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	
	rot_speed *= rand_range(0.9, 1.3) * sign(rand_range(-1, 1))
	
	connect("died", get_node("/root/score_manager"), "score_received", [points])
	get_node("Spawn").set_emitting(true)

func _fixed_process(delta):
	move(movement_dir * movement_speed * delta)
	
	if (is_colliding() && !collision_buffer):
		collision_buffer = true
		if (abs(get_collision_normal().x) > 0):
			movement_dir = Vector2(-movement_dir.x, movement_dir.y)
		if (abs(get_collision_normal().y) > 0):
			movement_dir = Vector2(movement_dir.x, -movement_dir.y)
	elif (collision_buffer):
		collision_buffer = false
	set_rot(get_rot() + deg2rad(rot_speed) * delta)

func take_damage(damage):
	health_points -= damage
	if (health_points <= 0):
		die()

func die():
	emit_signal("died")
	get_node("SamplePlayer2D").play("explosion")
	# disable enemy
	get_node("Sprite").set_hidden(true)
	get_node("Explode").set_emitting(true)
	set_fixed_process(false)
	set_layer_mask(0)
	set_collision_mask(0)
	# create death timer
	get_node("/root/callback").create("queue_free", self, 1)