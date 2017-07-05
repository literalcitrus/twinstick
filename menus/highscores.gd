extends CanvasLayer

const default_scores = {}

var current_scores = {}

onready var scores_text = get_node("Label/RichTextLabel")

func _ready():
	for i in range(0, 10):
		default_scores[i] = {"name":"", "score":0}
	
	var file = File.new()
	# create default file
	if (!file.file_exists("user://highscores.json")):
		file.open("user://highscores.json", file.WRITE)
		file.store_line(default_scores.to_json())
		file.close()
	
	# load file
	file.open("user://highscores.json", file.READ)
	var content = file.get_line()
	file.close()
	current_scores.parse_json(content)
	
	for i in range(0, 10):
		scores_text.add_text(str(i+1) + ": " + current_scores[str(i)]["name"] + " - " + str(current_scores[str(i)]["score"]) + "\n")

