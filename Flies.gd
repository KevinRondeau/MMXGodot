extends KinematicBody2D
export var speed=-200
export var gravity=20
var velocity=Vector2.ZERO
var FLOOR=Vector2(0,-1)
var state="MOVE"
var active=false
onready var stats=$Stats
onready var deatheffects=preload("res://DeadCircle.tscn")
var Circle

func _ready():
	stats.health=6
	stats.damage=4
	
func _physics_process(_delta):
	if active==true:
		if state=="MOVE":
			velocity.x=speed
			velocity=move_and_slide(velocity,FLOOR)

	
func _on_HurtBox_area_entered(area):
	if area.name.match("Bullet")||area.name.match("FirstCharge")||area.name.match("MaxCharge"):
		stats.health-=area.damage



func _on_DetectionZone_body_entered(body):
	if body.name.match("X"):
		self.active=true


func _on_FallZoneEnnemies_body_entered(body):
	body.queue_free()


func _on_Stats_zero_health():
	state="DEATH"
	self.queue_free()
