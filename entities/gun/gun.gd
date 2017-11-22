# gun.gd

extends Node2D

export(String, FILE, "*.tscn") var bullet_scene_path = "res://entities/bullet/Bullet.tscn"
export(String) var target_group
export(int) var bullet_speed = 1000
export(int) var rof = 3

var bullet_scene

onready var bullet_container = get_node("Bullets")
onready var timer_node = get_node("RateOfFire")

var is_firing = false # is the gun currently firing
var refire_available = true # is the gun ready to fire the next bullet
var facing_dir = Vector2(0,1) # the direction that the gun is aimed at

func _ready():
	bullet_scene = load(bullet_scene_path)
	timer_node.set_wait_time(1.0 / rof)
	set_fixed_process(true)

func _fixed_process(delta):
	# if gun is_firing and refire_available, then fire a bullet
	if (is_firing && refire_available):
		fire_bullet()
		refire_available = false
		timer_node.start()
	

func fire_bullet():
	# bullet creation
	var new_bullet = bullet_scene.instance()
	new_bullet.direction = facing_dir
	new_bullet.set_pos(get_global_pos())
	new_bullet.target_group = target_group
	new_bullet.movement_speed = bullet_speed
	bullet_container.add_child(new_bullet)

func _on_RateOfFire_timeout():
	refire_available = true
