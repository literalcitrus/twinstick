extends Label

const num_chars = 3

signal name_entered(name)

var name
var current_char = 0

var stick_locked = false

onready var name_node = get_node("Name")

func _ready():
	name = get_text()

func _input(event):
	if (event.is_action_pressed("ui_up") || (get_node("/root/input_manager").left_stick_input.y == -1 && !stick_locked)):
		stick_locked = true
		name = increment_char(name, current_char, 1)
	elif (event.is_action_pressed("ui_down") || (get_node("/root/input_manager").left_stick_input.y == 1 && !stick_locked)):
		stick_locked = true
		name = increment_char(name, current_char, -1)
	elif (get_node("/root/input_manager").left_stick_input.y == 0):
		stick_locked = false
	
	if ((event.is_action_pressed("ui_accept") || event.is_action_pressed("continue")) && !event.is_echo()):
		print("char set")
		current_char += 1
		if (current_char >= num_chars):
			emit_signal("name_entered", name)
		else:
			name += "A"
	
	if (name[current_char] > "Z"):
		name[current_char] = "A"
	elif (name[current_char] < "A"):
		name[current_char] = "Z"
	
	name_node.set_text(name)

func increment_char(full_string, index, increment):
	# turn back now
	full_string[index] = RawArray([full_string[index].to_ascii()[0] + increment]).get_string_from_ascii()
	return full_string