extends "res://MegaManX/StateMachineX.gd"

func _enter_state():
	if MMX.is_on_floor():
		MMX.velocity=Vector2.ZERO
	MMX.shoot()
	MMX.fire()
func _handle_input():
	if MMX.animationPlayer.get_current_animation_position()>0.7&&MMX.animationPlayer.get_current_animation()=="DashFire":
		MMX.can_dash=true
		MMX.lastState="Idle"
		return "Idle"
	if MMX.lastState=="Idle":
		MMX.velocity.y=0
	#GetInput
	MMX.input_vector=Vector2.ZERO
	MMX.input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	#input(Left/Right)
	if MMX.input_vector.x>0:
		MMX.face_right=true
	elif MMX.input_vector.x<0:
		MMX.face_right=false
	if MMX.face_right==true&&MMX.lastState!="Idle":
		if MMX.lastState=="Move"||MMX.jumpState=="Move":
			MMX.velocity.x=MMX.SPEED
		if MMX.lastState=="Dash"||MMX.jumpState=="Dash":
			MMX.velocity.x=MMX.DASHSPEED
	if MMX.face_right==false&&MMX.lastState!="Idle":
		if MMX.lastState=="Move"||MMX.jumpState=="Move":
			MMX.velocity.x=-MMX.SPEED
		if MMX.lastState=="Dash"||MMX.jumpState=="Dash":
			MMX.velocity.x=-MMX.DASHSPEED
	if MMX.input_vector==Vector2.ZERO&&MMX.lastState!="Dash":
		MMX.velocity.x=0
	#Jump
	if MMX.can_jump&&Input.is_action_just_pressed("Jump"):
		MMX.velocity.y+=MMX.JUMPFORCE
		MMX.can_jump=false
		MMX.lastState="Jump"
		return "Jump"
	if Input.is_action_just_pressed("Dash")&&MMX.can_dash&&MMX.is_on_floor():
		MMX.can_dash=false
		MMX.lastState="Dash"
		return "Dash"
	if MMX.is_on_floor()&&MMX.lastState=="Fall":
		MMX.lastState="Move"
		MMX.jumpState="Move"
		return "Move"
	if MMX.input_vector==Vector2.ZERO&&MMX.animationPlayer.current_animation=="RunFire":
		MMX.shot_ended() 
		
	MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
	MMX.shoot()
	if MMX.is_on_floor()&&MMX.lastState=="Fall"||MMX.is_on_floor()&&MMX.animationPlayer.current_animation=="JumpFire":
		MMX.lastState="Idle"
		MMX.jumpState="Move"
		return "Idle"
	if MMX.velocity.y>100&&!MMX.is_on_floor()&&MMX.shotTimer.time_left==0:
			MMX.lastState="Fall"
			return "Fall"
	if MMX.velocity.y>100&&MMX.animationPlayer.current_animation=="RunFire":
		MMX.lastState="Fall"
		return "Fall"
	if MMX.is_on_wall()&&MMX.animationPlayer.current_animation=="JumpFire":
		return "WallGrab"
	#NormalShot
	if Input.is_action_just_pressed("Attack")&&MMX.can_shoot:
		MMX.fire()

