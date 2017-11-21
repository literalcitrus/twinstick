extends Node

var left_stick_input = Vector2()
var right_stick_input = Vector2()

const stick_min = 0.1
const stick_max = 0.9

func _ready():
	set_process(true)

func _process(delta):
	left_stick_input = Vector2(Input.get_joy_axis(0, 0), Input.get_joy_axis(0, 1))
	if (abs(left_stick_input.x) < stick_min && abs(left_stick_input.y) < stick_min):
		left_stick_input = Vector2()
	if (abs(left_stick_input.x) > stick_max):
		left_stick_input = Vector2(sign(left_stick_input.x), left_stick_input.y)
	if (abs(left_stick_input.y) > stick_max):
		left_stick_input = Vector2(left_stick_input.x, sign(left_stick_input.y))
	
	if (Input.is_action_pressed("player_up") && !Input.is_action_pressed("player_down")):
		left_stick_input.y = -1
	elif (Input.is_action_pressed("player_down") && !Input.is_action_pressed("player_up")):
		left_stick_input.y = 1
	
	if (Input.is_action_pressed("player_right") && !Input.is_action_pressed("player_left")):
		left_stick_input.x = 1
	elif (Input.is_action_pressed("player_left") && !Input.is_action_pressed("player_right")):
		left_stick_input.x = -1
	
	right_stick_input = Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3))
	if (abs(right_stick_input.x) < stick_min && abs(right_stick_input.y) < stick_min):
		right_stick_input = Vector2()
	if (abs(right_stick_input.x) > stick_max):
		right_stick_input = Vector2(sign(right_stick_input.x), right_stick_input.y)
	if (abs(right_stick_input.y) > stick_max):
		right_stick_input = Vector2(right_stick_input.x, sign(right_stick_input.y))
	
	if (Input.is_action_pressed("shoot_up") && !Input.is_action_pressed("shoot_down")):
		right_stick_input.y = -1
	elif (Input.is_action_pressed("shoot_down") && !Input.is_action_pressed("shoot_up")):
		right_stick_input.y = 1
	
	if (Input.is_action_pressed("shoot_right") && !Input.is_action_pressed("shoot_left")):
		right_stick_input.x = 1
	elif (Input.is_action_pressed("shoot_left") && !Input.is_action_pressed("shoot_right")):
		right_stick_input.x = -1
