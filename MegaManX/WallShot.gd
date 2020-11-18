extends "res://MegaManX/StateMachineX.gd"

func _enter_state():
	MMX.animationPlayer.play("WallShot")
	MMX.shoot()
	MMX.fire()
	
		
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
	#NormalShot
	if Input.is_action_just_pressed("Attack")&&MMX.can_shoot:
		MMX.shoot()
		MMX.fire()
		
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
	MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
