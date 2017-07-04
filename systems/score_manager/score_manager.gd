extends Node

signal score(value)

func score_received(score):
	emit_signal("score", score)
