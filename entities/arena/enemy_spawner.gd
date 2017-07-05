extends Node

const player_buffer = 300

var enemy_scenes = [preload("res://entities/enemy/Asteroid.tscn"), \
					preload("res://entities/enemy/Fighter.tscn")]
var prespawn_scene = preload("res://entities/enemy/PreSpawn.tscn")

var wave = 0
var num_enemies = 0
var spawning = true

onready var arena_node = get_parent()
onready var spawn_timer = get_node("SpawnTimer")

signal spawned_wave(enemies)

func _ready():
	randomize()
	set_process(true)
	
	get_tree().get_nodes_in_group("player")[0].connect("died", self, "stop_spawning")

func _process(delta):
	if (num_enemies == 0):
		wave += 1
		spawn_wave()

func spawn_wave():
	if (!spawning):
		return
	var new_spawns = []
	var player = get_tree().get_nodes_in_group("player")[0]
	num_enemies = wave
	for n in range(0, wave):
		var new_enemy = enemy_scenes[floor(rand_range(0, enemy_scenes.size()))].instance()
		var new_pos = Vector2(rand_range(-arena_node.arena_size.x / 2 + 50, arena_node.arena_size.x / 2 - 50), \
			rand_range(-arena_node.arena_size.y / 2 + 50, arena_node.arena_size.y / 2 - 50))
		while(new_pos.distance_to(player.get_global_pos()) < player_buffer):
			new_pos = Vector2(rand_range(-arena_node.arena_size.x / 2 + 50, arena_node.arena_size.x / 2 - 50), \
				rand_range(-arena_node.arena_size.y / 2 + 50, arena_node.arena_size.y / 2 - 50))
		new_enemy.set_pos(new_pos)
		new_enemy.connect("died", self, "enemy_died")
		
		var new_spawn = prespawn_scene.instance()
		new_spawn.enemy = new_enemy
		new_spawn.set_pos(new_pos)
		add_child(new_spawn)
		new_spawns.append(new_enemy)
	
	emit_signal("spawned_wave", new_spawns)
	# set spawn timer
	spawn_timer.set_wait_time(2 * log(wave) + 1)
	spawn_timer.start()

func enemy_died():
	num_enemies -= 1

func _on_SpawnTimer_timeout():
	wave += 1
	spawn_wave()

func stop_spawning():
	spawning = false