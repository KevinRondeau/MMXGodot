extends "res://MegaManX/StateMachineX.gd"

func _enter_state():
	MMX.animationPlayer.play("Jump")
	MMX.animationPlayer.seek(0.8)
		
func _handle_input():
	MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
	if MMX.is_on_floor():
		MMX.lastState="Move"
		MMX.jumpState="Move"
		MMX.can_dash=true
		MMX.can_jump=true
		return "Move"
	#GetInput
	MMX.input_vector=Vector2.ZERO
	MMX.input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	if MMX.input_vector.x>0:
		MMX.face_right=true
		if MMX.jumpState=="Move":
			MMX.velocity.x=MMX.SPEED
		if MMX.jumpState=="Dash":
			MMX.velocity.x=MMX.DASHSPEED
	elif MMX.input_vector.x<0:
		MMX.face_right=false
		if MMX.jumpState=="Move":
			MMX.velocity.x=-MMX.SPEED
		if MMX.jumpState=="Dash":
			MMX.velocity.x=-MMX.DASHSPEED
	if MMX.input_vector==Vector2.ZERO:
		MMX.velocity.x=0
		MMX.jumpState="Move"

	#Shoot
	if Input.is_action_just_released("Attack")&&MMX.can_shoot&&MMX.charge>50:
		MMX.lastState="Fall"
		return "Shoot"
		#NormalShot
	if Input.is_action_just_pressed("Attack")&&MMX.can_shoot:
		MMX.lastState="Fall"
		return "Shoot"
	if MMX.is_on_wall()&&MMX.input_vector.x!=0:
		return "WallGrab"

