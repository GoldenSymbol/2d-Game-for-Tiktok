extends Node

var player : Player

func respawn_player():
	get_tree().reload_current_scene()
