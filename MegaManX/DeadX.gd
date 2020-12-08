extends "res://MegaManX/StateMachineX.gd"
onready var deatheffects=preload("res://DeadCircle.tscn")
var Circle
func _enter_state():
	Circle=deatheffects.instance()
	Circle.position=MMX.global_position
	MMX.get_parent().add_child(Circle)
	MMX.DeadTimer.start(1.5)
	
func _handle_input():
	MMX.velocity=Vector2.ZERO
