extends KinematicBody2D

# node references
onready var movement = get_node("ShipMovement")
onready var input = get_node("/root/input_manager")
onready var sprite = get_node("Sprite")
var gun

# export vars
export(bool) var is_player = false # is the ship controlled by the player
export(String, FILE) var gun_scene = "res://entities/gun/Gun.tscn"
export(String, "blue", "red") var team = "blue"

func _ready():
	set_fixed_process(true)
	if (gun_scene != ""):
		gun = load(gun_scene).instance()
		add_child(gun)
	
	if (team == "red"):
		add_to_group("team_red")
		gun.target_group = "team_blue"
		sprite.set_modulate(Color(1,0,0))
	else:
		add_to_group("team_blue")
		gun.target_group = "team_red"

func _fixed_process(delta):
	# if ship is player controller, pull input from input manager
	# otherwise, use AI
	if (is_player):
		# use player
		move(movement.process_movement(input.left_stick_input, delta))
		if (input.right_stick_input != Vector2()):
			gun.is_firing = true
			gun.facing_dir = input.right_stick_input
		else:
			gun.is_firing = false
			
	else:
		# use AI
		pass
