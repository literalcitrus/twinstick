extends CanvasLayer

const default_scores = {}

var current_scores = {}
onready var score_table = get_node("Control/ScoreTable")
onready var scores_text = get_node("Control/ScoreTable/RichTextLabel")
onready var name_input = get_node("Control/HighscoreNameInput")

var temp_score

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
	
	name_input.connect("name_entered", self, "name_received")

func display_scores():
	for i in range(0, 10):
		scores_text.add_text(str(i+1) + ": " + current_scores[str(i)]["name"] + " - " + str(current_scores[str(i)]["score"]) + "\n")

func check_score(score):
	for i in range(0, 10):
		if (score >= current_scores[str(i)]["score"]):
			return i
	
	return -1

func insert_score(score, rank, name):
	var temp_score = {"name":name, "score":score}
	for i in range(rank, 9):
		temp_score = current_scores[str(i+1)]
		current_scores[str(i)] = temp_score

func get_highscore_name(score):
	score_table.set_hidden(true)
	name_input.set_hidden(false)
	name_input.set_process_input(true)
	temp_score = score

func final_score(score):
	var rank = check_score(score)
	if (rank != -1):
		get_highscore_name(score)

func name_received(name):
	insert_score(temp_score, check_score(temp_score), name)
	display_scores()