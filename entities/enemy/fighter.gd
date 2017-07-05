extends KinematicBody2D

const max_movement_speed = 600
const accel_amount = 1000
const rate_of_fire = 2
const fire_cone = 45
const fire_distance = 800
const bullet_speed = 800
const points = 100

signal died()

var health_points = 1
var target_node
var velocity = Vector2()
var accel = Vector2()

onready var timer_node = get_node("RateOfFireTimer")
onready var sound_node = get_node("SamplePlayer2D")

var bullet_scene = preload("res://entities/bullet/Bullet.tscn")

func _ready():
	target_node = get_tree().get_nodes_in_group("player")[0]
	timer_node.set_wait_time(1.0 / rate_of_fire)
	set_fixed_process(true)
	
	connect("died", get_node("/root/score_manager"), "score_received", [points])
	get_node("Spawn").set_emitting(true)

func _fixed_process(delta):
	var tracking_dir = (target_node.get_global_pos() - get_global_pos()).normalized()
	accel = tracking_dir * accel_amount * delta
	velocity += accel
	
	# clamp velocity
	if (velocity.length() > max_movement_speed):
		velocity = velocity.normalized() * max_movement_speed
	
	var motion = velocity * delta
	motion = move(motion)
	
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		move(motion)
	
	set_rot(velocity.angle())
	
	if (velocity.angle_to_point(target_node.get_global_pos()) < deg2rad(fire_cone) && get_global_pos().distance_to(target_node.get_global_pos()) < fire_distance):
		fire_bullet()

func take_damage(damage):
	health_points -= damage
	if (health_points <= 0):
		die()

func fire_bullet():
	if (timer_node.get_time_left() == 0):
		# bullet creation
		var new_bullet = bullet_scene.instance()
		new_bullet.direction = velocity.normalized()
		new_bullet.set_pos(get_pos())
		new_bullet.movement_speed = bullet_speed
		new_bullet.target_group = "player"
		get_node("Bullets").add_child(new_bullet)
		# start timer
		timer_node.start()
		# audio
		sound_node.play("bullet")

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