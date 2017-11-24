extends Node2D

# node references
onready var detection = get_node("Detection")

# export vars
export(int) var detection_range = 100 # detection range in pixels

# input references
var left_stick_input = Vector2()
var right_stick_input = Vector2()

# ai vars
var destination = Vector2()

func _ready():
	randomize()
	detection.get_shape(0).set_radius(detection_range)
	destination = generate_destination()

func get_movement():
	left_stick_input = (destination - get_global_pos()).normalized()

func generate_destination():
	return get_global_pos() + Vector2(0, 1).rotated(rand_range(0, deg2rad(360))) * detection_range

func _on_Detection_body_enter( body ):
	pass # replace with function body

func _on_Detection_body_exit( body ):
	pass # replace with function body
