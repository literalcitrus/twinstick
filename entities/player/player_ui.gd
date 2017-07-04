extends Node2D

func _ready():
	pass

func update_score(new_score):
	get_node("Score").set_text(str(new_score))