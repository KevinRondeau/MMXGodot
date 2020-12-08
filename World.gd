extends Node2D


func _ready():
	pass


func _on_Launcher_dead():
	PlayerStats.set_health(32)
	get_tree().reload_current_scene()
