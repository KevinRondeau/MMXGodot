extends KinematicBody2D
export var speed=-100
export var jumpforce=-500
export var gravity=20
var velocity=Vector2.ZERO
var FLOOR=Vector2(0,-1)
var state="MOVE"
var active=false
onready var stats=$Stats
onready var deatheffects=preload("res://DeadCircle.tscn")
var Circle

func _ready():
	stats.health=10
	stats.damage=4
	
func _physics_process(_delta):
	if active==true:
		if state=="MOVE":
			velocity.x=speed
			velocity.y+=gravity
			velocity=move_and_slide(velocity,FLOOR)

	
func _on_HurtBox_area_entered(area):
	if !area.name.match("FallZoneEnnemies")&&!area.name.match("HurtBox"):
		stats.health-=area.damage


func _on_DeathTimer_timeout():
	$AnimatedSprite.visible=false
	self.queue_free()


func _on_DetectionZone_body_entered(_body):
		active=true


func _on_FallZoneEnnemies_body_entered(body):
	body.queue_free()


func _on_Stats_zero_health():
	state="DEATH"
	$DeathTimer.start(0.6)
	$AnimatedSprite.animation="Die"
	$CollisionShape2D.queue_free()
	$HurtBox/CollisionShape2D.queue_free()
	active=false
