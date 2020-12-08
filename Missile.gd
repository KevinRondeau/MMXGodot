extends Area2D

const SPEED=250
var velocity=Vector2()
var direction=1
var damage=6

func _ready():
	$AnimatedSprite.play("default")
func set_direction(dir):
	direction=dir

func _physics_process(delta):
	velocity.x=SPEED*delta*direction
	translate(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Missile_body_entered(_body):
	velocity.x=0
	queue_free()
