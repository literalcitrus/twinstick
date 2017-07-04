# callback.gd

extends Node

func _ready():
	set_process(true)

func create(function_name, node, time):
	var new_timer = Timer.new()
	add_child(new_timer)
	new_timer.set_wait_time(time)
	new_timer.connect("timeout", self, "run_callback", [new_timer, function_name, node])
	new_timer.start()

func run_callback(timer_node, function_name, node):
	timer_node.queue_free()
	var callback_func = funcref(node, function_name)
	callback_func.call_func()