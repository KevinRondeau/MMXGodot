extends "res://MegaManX/StateMachineX.gd"

func _enter_state():
	MMX.animationPlayer.play("WallKick")
	MMX.SFX.stream=MMX.WallKickSound
	MMX.SFX.play()
		
func _handle_input():
			
	if Input.is_action_just_released("Attack"):
		MMX.FirstParticle.emitting=false
		MMX.FirstParticle.visible=false
		MMX.FullParticle.emitting=false
		MMX.FullParticle.visible=false
		MMX.lastState="Fall"
		return "Shoot"
	#Charge
	if Input.is_action_pressed("Attack"):
		MMX.charge+=1

	MMX.velocity=MMX.move_and_slide(MMX.velocity,MMX.FLOOR)
	if MMX.animationPlayer.get_current_animation_position()>0.18:
		MMX.lastState="Fall"
		return "Fall"
