extends Node2D

var indicator_scene = preload("res://entities/player/Indicator.tscn")

func _ready():
	get_tree().get_nodes_in_group("arena")[0].get_node("Enemies").connect("spawned_wave", self, "wave_spawned")

func wave_spawned(enemies):
	for enemy in enemies:
		var new_indicator = indicator_scene.instance()
		new_indicator.indicating = enemy
		enemy.connect("died", new_indicator, "die")
		add_child(new_indicator)
