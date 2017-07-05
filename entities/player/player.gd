extends KinematicBody2D

const max_movement_speed = 400
const rate_of_fire = 6
const accel_amount = 900
const turn_rate = 10
const bullet_speed = 2000

signal died()

var left_stick_input = Vector2()
var right_stick_input = Vector2()
var facing_dir = Vector2(1, 0)
var velocity = Vector2()
var accel = Vector2()
var score = 0
var health_points = 1

onready var timer_node = get_node("RateOfFireTimer")
onready var radar_node = get_node("Radar")
onready var particles_node = get_node("Sprite/Particles2D")
onready var sound_node = get_node("SamplePlayer2D")
onready var ui_node = get_node("PlayerUI")

var bullet_scene = preload("res://entities/bullet/Bullet.tscn")
var game_over_scene = preload("res://menus/GameOver.tscn")
var explode = preload("res://entities/player/Explode.tscn")

func _ready():
	set_fixed_process(true)
	set_process(true)
	timer_node.set_wait_time(1.0 / rate_of_fire)
	get_node("/root/camera").track_node = self
	get_node("/root/score_manager").connect("score", self, "receive_score")
	get_node("Spawn").set_emitting(true)

func _fixed_process(delta):
	left_stick_input = get_node("/root/input_manager").left_stick_input
	if (right_stick_input != Vector2()):
		facing_dir = turn_towards(facing_dir, right_stick_input.normalized(), delta)
	else:
		if (left_stick_input != Vector2()):
			facing_dir = velocity.normalized()
	
	if (left_stick_input == Vector2()):
		accel = -velocity.normalized() * accel_amount * delta
	else:
		accel = left_stick_input * accel_amount * delta
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
	
	set_rot(facing_dir.angle())

func _process(delta):
	right_stick_input = get_node("/root/input_manager").right_stick_input
	if (right_stick_input.normalized() != Vector2()):
		facing_dir = right_stick_input.normalized()
		fire_bullet()
	
	radar_node.set_global_rot(0)
	ui_node.set_global_rot(0)
	
	if (velocity == Vector2()):
		particles_node.set_emitting(false)
	else:
		particles_node.set_emitting(true)

func turn_towards(current, destination, delta):
	if (destination == Vector2()):
		return current
	if (abs(rad2deg(current.angle_to(destination))) < turn_rate * delta):
		return destination
	else :
		return current.rotated(sign(current.angle_to(destination)) * deg2rad(turn_rate * delta)).normalized()

func fire_bullet():
	if (timer_node.get_time_left() == 0):
		# bullet creation
		var new_bullet = bullet_scene.instance()
		new_bullet.direction = facing_dir
		new_bullet.set_pos(get_pos())
		new_bullet.target_group = "enemy"
		new_bullet.movement_speed = bullet_speed
		get_node("Bullets").add_child(new_bullet)
		# start timer
		timer_node.start()
		# audio
		sound_node.play("bullet")

func take_damage(damage):
	health_points -= damage
	if (health_points <= 0):
		die()

func die():
	get_node("/root/camera").track_node = null
	sound_node.play("explosion")
	get_node("Sprite").set_hidden(true)
	radar_node.set_hidden(true)
	ui_node.set_hidden(true)
	set_process(false)
	set_fixed_process(false)
	set_collision_mask(0)
	set_layer_mask(0)
	get_node("Hurtbox").set_collision_mask(0)
	get_node("Hurtbox").set_layer_mask(0)
	get_node("/root/callback").create("game_over", self, 1)
	var new_explode = explode.instance()
	add_child(new_explode)
	new_explode.set_hidden(false)
	new_explode.set_emitting(true)
	
	emit_signal("died")

func _on_Area2D_body_enter( body ):
	if (body.is_in_group("enemy")):
		take_damage(1)

func game_over():
	var new_game_over = game_over_scene.instance()
	new_game_over.set_score(score)
	add_child(new_game_over)

func receive_score(added_points):
	score += added_points
	ui_node.update_score(score)