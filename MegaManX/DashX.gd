extends "res://MegaManX/StateMachineX.gd"

func _enter_state():
	MMX.currentAnimation=MMX.animationPlayer.current_animation_position
	MMX.animationPlayer.play("Dash")
	if MMX.lastState=="Shoot":
		MMX.animationPlayer.seek(MMX.currentAnimation)
	
func _handle_input():
	if MMX.animationPlayer.get_current_animation_position()>0.75:
		MMX.can_dash=true
		if !MMX.is_on_floor():
			MMX.lastState="Fall"
			return "Fall"
		else:
			MMX.lastState="Idle"
			return "Idle"
	#GetInput
	MMX.input_vector=Vector2.ZERO
	MMX.input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	#Jump
	if MMX.can_jump&&Input.is_action_just_pressed("Jump"):
		MMX.SFX.stop()
		MMX.SFX.stream=MMX.JumpSound
		MMX.SFX.play()
		MMX.lastState="Jump"
		MMX.velocity.y+=MMX.JUMPFORCE
		MMX.can_jump=false
		MMX.jumpState="Dash"
		return "Jump"
		
	if Input.is_action_just_released("Attack")&&MMX.can_shoot&&MMX.charge>50:
		MMX.lastState="Dash"
		return "Shoot"
		#NormalShot
	if Input.is_action_just_pressed("Attack")&&MMX.can_shoot:
		MMX.lastState="Dash"
		return "Shoot"
	
	if MMX.face_right==true:
		MMX.velocity.x=MMX.DASHSPEED
	if MMX.face_right==false:
		MMX.velocity.x=-MMX.DASHSPEED
	if Input.is_action_just_released("Dash"):
		MMX.SFX.stop()
		if !MMX.is_on_floor():
			MMX.lastState="Fall"
			return "Fall"
		else:
			MMX.lastState="Idle"
			return "Idle"
		
	MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
	
	if MMX.is_on_floor():
		MMX.can_jump=true
	
