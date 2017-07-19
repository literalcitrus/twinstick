# gun.gd

extends Node2D

export(String, FILE, "*.tscn") var bullet_scene_path
export(String) var target_group
export(int) var bullet_speed
export(int) var rof

var bullet_scene

onready var bullet_container = get_node("Bullets")
onready var timer_node = get_node("RateOfFire")
onready var sound_node = get_node("SamplePlayer2D")

func _ready():
	bullet_scene = load(bullet_scene_path)
	timer_node.set_wait_time(1.0 / rof)

func fire_bullet(facing_dir):
	if (timer_node.get_time_left() == 0):
		# bullet creation
		var new_bullet = bullet_scene.instance()
		new_bullet.direction = facing_dir
		new_bullet.set_pos(get_global_pos())
		new_bullet.target_group = target_group
		new_bullet.movement_speed = bullet_speed
		bullet_container.add_child(new_bullet)
		# start timer
		timer_node.start()
		# audio
		sound_node.play("bullet")