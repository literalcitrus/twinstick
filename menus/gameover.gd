extends CanvasLayer

func _ready():
	set_process_input(true)

func _input(event):
	if (event.is_action_pressed("continue")):
		get_tree().reload_current_scene()

func set_score(score):
	get_node("Label/Label1").set_text("Score: " + str(score))