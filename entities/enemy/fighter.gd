extends KinematicBody2D

const fire_cone = 90
const fire_distance = 800
const points = 100

signal died()

var health_points = 1
var target_node
var velocity = Vector2()
var accel = Vector2()
var gun_locked = true

onready var sound_node = get_node("SamplePlayer2D")
onready var gun_node = get_node("Gun")
onready var movement_node = get_node("ShipMovement")

func _ready():
	target_node = get_tree().get_nodes_in_group("player")[0]
	set_fixed_process(true)
	
	connect("died", get_node("/root/score_manager"), "score_received", [points])
	get_node("Spawn").set_emitting(true)

func _fixed_process(delta):
	var tracking_dir = (target_node.get_global_pos() - get_global_pos()).normalized()
	
	move(movement_node.process_movement(tracking_dir, delta))
	
	set_rot(movement_node.velocity.angle())
	
	if (movement_node.velocity.angle_to_point(target_node.get_global_pos()) < deg2rad(fire_cone) && get_global_pos().distance_to(target_node.get_global_pos()) < fire_distance && !gun_locked):
		gun_node.fire_bullet(movement_node.velocity.normalized())

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

func _on_GunInactiveTimer_timeout():
	gun_locked = false
