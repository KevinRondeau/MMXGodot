extends "res://MegaManX/StateMachineX.gd"

func _ready():
	pass

func _enter_state():
	MMX.animationPlayer.play("Idle")
	if MMX.is_on_floor():
		MMX.velocity=Vector2.ZERO
	
func _handle_input():
	MMX.can_dash=true
	MMX.velocity=Vector2.ZERO
	#GetInput
	MMX.input_vector=Vector2.ZERO
	MMX.input_vector.x=Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	#Move
	if MMX.input_vector!=Vector2.ZERO:
		MMX.lastState="Move"
		return "Move"
	#Jump
	if MMX.can_jump&&Input.is_action_just_pressed("Jump"):
		MMX.SFX.stream=MMX.JumpSound
		MMX.SFX.play()
		MMX.lastState="Jump"
		MMX.velocity.y+=MMX.JUMPFORCE
		MMX.can_jump=false
		MMX.jumpState="Move"
		return "Jump"
		
	if Input.is_action_just_released("Attack")&&MMX.can_shoot&&MMX.charge>50:
		MMX.lastState="Idle"
		return "Shoot"
		#NormalShot
	if Input.is_action_just_pressed("Attack")&&MMX.can_shoot:
		MMX.lastState="Idle"
		return "Shoot"
	if Input.is_action_just_pressed("Dash")&&MMX.can_dash:
		MMX.lastState="Dash"
		MMX.can_dash=false
		MMX.SFX.stream=MMX.DashSound
		MMX.SFX.play()
		return "Dash"
	if Input.is_action_just_released("Dash"):
		MMX.can_dash=true
	MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
	
	if MMX.velocity.y>100&&!MMX.is_on_floor():
		MMX.lastState="Fall"
		MMX.can_jump=false
		return "Fall"
	if MMX.is_on_floor():
		MMX.can_jump=true
