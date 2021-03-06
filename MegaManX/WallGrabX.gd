extends "res://MegaManX/StateMachineX.gd"

func _enter_state():
	if MMX.velocity.y<0:
		MMX.velocity.y=0
	if MMX.animationPlayer.current_animation!="WallGrab":
		MMX.animationPlayer.play("WallGrab")
	MMX.lastState="WallGrab"
	
		
func _handle_input():

	#GetInput
	MMX.input_vector=Vector2.ZERO
	MMX.input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	if MMX.face_right==true&&MMX.input_vector.x>0:
		MMX.velocity.x=MMX.SPEED
	if MMX.face_right==false&&MMX.input_vector.x<0:
		MMX.velocity.x=-MMX.SPEED
	if MMX.face_right==true&&MMX.input_vector.x<=0:
		MMX.lastState="Fall"
		return "Fall"
	elif MMX.face_right==false&&MMX.input_vector.x>=0:
		MMX.lastState="Fall"
		return "Fall"
	if MMX.is_on_floor():
		MMX.lastState="Idle"
		return "Idle"
		
	if Input.is_action_just_pressed("Jump")&&Input.is_action_pressed("Dash"):
		if MMX.face_right==true:
			MMX.velocity.x=-MMX.SPEED*2.0
			MMX.velocity.y=MMX.JUMPFORCE
			MMX.jumpState="Dash"
			MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
			return "WallKick"
		if MMX.face_right==false:
			MMX.velocity.x=MMX.SPEED*2.0
			MMX.velocity.y=MMX.JUMPFORCE
			MMX.jumpState="Dash"
			MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
			return "WallKick"
	if Input.is_action_just_pressed("Jump"):
		if MMX.face_right==true:
			MMX.velocity.x=-MMX.SPEED*1.5
			MMX.velocity.y=MMX.JUMPFORCE
			MMX.jumpState="Move"
			MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
			return "WallKick"
		if MMX.face_right==false:
			MMX.velocity.x=MMX.SPEED*1.5
			MMX.velocity.y=MMX.JUMPFORCE
			MMX.jumpState="Move"
			MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
			return "WallKick"
	if Input.is_action_just_released("Attack")&&MMX.can_shoot&&MMX.charge>50:
		MMX.lastState="WallGrab"
		return "WallShot"
	#NormalShot
	if Input.is_action_just_pressed("Attack")&&MMX.can_shoot:
		MMX.lastState="WallGrab"
		return "WallShot"
	MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
