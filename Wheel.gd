extends KinematicBody2D
export var health=10
export var speed=-100
export var jumpforce=-500
export var gravity=20
var velocity=Vector2.ZERO
var FLOOR=Vector2(0,-1)
var state="MOVE"
var active=false

func _physics_process(_delta):
	if active==true:
		if state=="MOVE":
			velocity.x=speed
			velocity.y+=gravity
			velocity=move_and_slide(velocity,FLOOR)

	
func _on_HurtBox_area_entered(area):
	if !area.name.match("FallZoneEnnemies"):
		health-=area.damage
		if health<=0&&active:
			state="DEATH"
			$DeathTimer.start(0.6)
			$AnimatedSprite.animation="Die"
			active=false


func _on_DeathTimer_timeout():
	queue_free()


func _on_DetectionZone_body_entered(body):
	if body.name.match("X"):
		active=true


func _on_FallZoneEnnemies_body_entered(body):
	body.queue_free()
