extends Area2D

const SPEED=750
var velocity=Vector2()
var direction=1
var state=0
var damage=15

func _ready():
	$AnimatedSprite.play("Spawn")

func set_direction(dir):
	direction=dir
	if dir==-1:
		$AnimatedSprite.flip_h=true

func _physics_process(delta):
	if state==0:
		velocity.x=SPEED*delta*direction
		translate(velocity)
		$AnimatedSprite.play("Shot")


func _on_VisibilityNotifierMax_screen_exited():
	queue_free()


func _on_MaxCharge_body_entered(_body):
	state=1
	velocity.x=0
	$AnimatedSprite.play("Hit")
	$HitMaxTimer.start(0.2)


func _on_HitMaxTimer_timeout():
	queue_free()
