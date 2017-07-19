extends KinematicBody2D

const shooting_deadzone = 0.5

signal died()

var left_stick_input = Vector2()
var right_stick_input = Vector2()
var facing_dir = Vector2(1, 0)
var score = 0
var health_points = 1

onready var radar_node = get_node("Radar")
onready var particles_node = get_node("Sprite/Particles2D")
onready var sound_node = get_node("SamplePlayer2D")
onready var ui_node = get_node("PlayerUI")
onready var gun_node = get_node("Gun")
onready var movement_node = get_node("ShipMovement")

var game_over_scene = preload("res://menus/GameOver.tscn")
var explode = preload("res://entities/player/Explode.tscn")

func _ready():
	set_fixed_process(true)
	set_process(true)
	get_node("/root/camera").track_node = self
	get_node("/root/score_manager").connect("score", self, "receive_score")
	get_node("Spawn").set_emitting(true)

func _fixed_process(delta):
	left_stick_input = get_node("/root/input_manager").left_stick_input
	if (right_stick_input != Vector2()):
		facing_dir = right_stick_input
	else:
		if (left_stick_input != Vector2()):
			facing_dir = movement_node.velocity.normalized()
		else:
			facing_dir = left_stick_input
	
	move(movement_node.process_movement(left_stick_input, delta))
	
	set_rot(facing_dir.angle())

func _process(delta):
	right_stick_input = get_node("/root/input_manager").right_stick_input
	if (right_stick_input.length() > shooting_deadzone):
		facing_dir = right_stick_input.normalized()
		gun_node.fire_bullet(facing_dir)
	
	radar_node.set_global_rot(0)
	ui_node.set_global_rot(0)
	
	if (left_stick_input == Vector2()):
		particles_node.set_emitting(false)
	else:
		particles_node.set_emitting(true)

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