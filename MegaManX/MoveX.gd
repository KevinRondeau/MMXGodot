extends "res://MegaManX/StateMachineX.gd"

func _enter_state():
	MMX.currentAnimation=MMX.animationPlayer.current_animation_position
	MMX.animationPlayer.play("Run")
	if MMX.lastState=="Shoot":
		MMX.animationPlayer.seek(MMX.currentAnimation)
	if MMX.is_on_floor():
		MMX.velocity=Vector2.ZERO
		
func _handle_input():
	MMX.can_dash=true
	#GetInput
	MMX.input_vector=Vector2.ZERO
	MMX.input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	#Move
	if MMX.input_vector==Vector2.ZERO&&MMX.can_dash:
		MMX.lastState="Idle"
		return "Idle"
	#Jump
	if MMX.can_jump&&Input.is_action_just_pressed("Jump"):
		MMX.SFX.stream=MMX.JumpSound
		MMX.SFX.play()
		MMX.velocity.y+=MMX.JUMPFORCE
		MMX.can_jump=false
		MMX.jumpState="Move"
		MMX.lastState="Jump"
		return "Jump"
	if Input.is_action_just_released("Attack")&&MMX.can_shoot&&MMX.charge>50:
		MMX.lastState="Move"
		return "Shoot"
	#NormalShot
	if Input.is_action_just_pressed("Attack")&&MMX.can_shoot:
		MMX.lastState="Move"
		return "Shoot"
	if Input.is_action_just_pressed("Attack")&&Input.is_action_just_pressed("Jump")&&MMX.can_shoot:
		MMX.lastState="Jump"
		return "Shoot"
	#Dash
	if Input.is_action_just_pressed("Dash")&&MMX.can_dash:
		MMX.can_dash=false
		MMX.lastState="Dash"
		MMX.SFX.stream=MMX.DashSound
		MMX.SFX.play()
		return "Dash"
	#input(Left/Right)
	if MMX.input_vector.x>0:
		MMX.face_right=true
		MMX.velocity.x=MMX.SPEED
	elif MMX.input_vector.x<0:
		MMX.face_right=false
		MMX.velocity.x=-MMX.SPEED
	MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
	
	if MMX.velocity.y>100&&!MMX.is_on_floor():
		MMX.lastState="Fall"
		MMX.can_jump=false
		return "Fall"
	
	if Input.is_action_just_released("Dash"):
		MMX.can_dash=true
		
	if MMX.is_on_floor():
		MMX.can_jump=true
		
