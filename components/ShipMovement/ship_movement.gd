extends Node2D

export(int) var max_movement_speed
export(int) var accel_amount

var velocity = Vector2()
var accel = Vector2()

func process_movement(input_vector, delta):
	if (input_vector == Vector2()):
		accel = -velocity.normalized() * accel_amount * delta
	else:
		accel = input_vector * accel_amount * delta
	velocity += accel
	
	# clamp velocity
	if (velocity.length() > max_movement_speed):
		velocity = velocity.normalized() * max_movement_speed
	
	return velocity * delta
