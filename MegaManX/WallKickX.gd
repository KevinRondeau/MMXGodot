extends "res://MegaManX/StateMachineX.gd"

func _enter_state():
	MMX.animationPlayer.play("WallKick")
	MMX.SFX.stream=MMX.WallKickSound
	MMX.SFX.play()
		
func _handle_input():
	MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
	if MMX.animationPlayer.get_current_animation_position()>0.18:
		MMX.lastState="Fall"
		return "Fall"
	if Input.is_action_just_released("Attack")&&MMX.can_shoot&&MMX.charge>50:
		MMX.lastState="Fall"
		MMX.shoot()
		MMX.fire()
	#NormalShot
	if Input.is_action_just_pressed("Attack")&&MMX.can_shoot:
		MMX.lastState="Fall"
		MMX.shoot()
		MMX.fire()
