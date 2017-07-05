extends Particles2D

var enemy

func _ready():
	pass


func _on_Timer_timeout():
	get_parent().add_child(enemy)
	queue_free()
