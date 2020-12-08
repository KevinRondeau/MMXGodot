extends "res://MegaManX/StateMachineX.gd"

func _enter_state():
	MMX.animationPlayer.play("Hurt")
	MMX.velocity=Vector2.ZERO
	
func _handle_input():
	MMX.velocity=Vector2.ZERO
