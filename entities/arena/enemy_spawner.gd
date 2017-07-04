extends Node

var enemy_scene = preload("res://entities/enemy/Asteroid.tscn")
var wave = 1

var num_enemies = 0

onready var arena_node = get_parent()

signal spawned_wave(enemies)

func _ready():
	set_process(true)

func _process(delta):
	if (num_enemies == 0):
		wave += 1
		spawn_wave()

func spawn_wave():
	var new_spawns = []
	var player = get_tree().get_nodes_in_group("player")[0]
	num_enemies = wave
	for n in range(0, wave):
		var new_enemy = enemy_scene.instance()
		var new_pos = Vector2(rand_range(-arena_node.arena_size.x / 2 + 50, arena_node.arena_size.x / 2 - 50), \
			rand_range(-arena_node.arena_size.y / 2 + 50, arena_node.arena_size.y / 2 - 50))
		while(new_pos.distance_to(player.get_global_pos()) < 200):
			new_pos = Vector2(rand_range(-arena_node.arena_size.x / 2 + 50, arena_node.arena_size.x / 2 - 50), \
				rand_range(-arena_node.arena_size.y / 2 + 50, arena_node.arena_size.y / 2 - 50))
		new_enemy.set_pos(new_pos)
		new_enemy.connect("died", self, "enemy_died")
		add_child(new_enemy)
		new_spawns.append(new_enemy)
	
	emit_signal("spawned_wave", new_spawns)

func enemy_died():
	num_enemies -= 1