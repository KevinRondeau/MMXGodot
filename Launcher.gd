extends KinematicBody2D
export var gravity=20
var state="Idle"
var active=false
onready var stats=$Stats
onready var deatheffects=preload("res://DeadCircle.tscn")
onready var missile=preload("res://Missile.tscn")
onready var spark=preload("res://Spark.tscn")
onready var Spark1=$Spark1
onready var Spark2=$Spark2
onready var Missile1=$Missile1
onready var Missile2=$Missile2
onready var animationPlayer=$AnimationPlayer
onready var collision=$CollisionShape2D
var lastState="ShootSpark"
var Circle
var missile1
var missile2
var spark1
var spark2
var attacking=false
signal dead

func _ready():
	stats.health=150
	stats.damage=6
	
func _physics_process(_delta):
	if active==true:
		if state=="Idle":
			animationPlayer.play("Idle")
		elif state=="ShootSpark"&&!attacking:
			_shoot_sparks()
		elif state=="ShootMissile"&&!attacking:
			_shoot_missiles()

	
func _on_HurtBox_area_entered(area):
	if !area.name.match("FallZoneEnnemies")&&!area.name.match("HurtBox")&&!area.name.match("DetectionZone"):
		stats.health-=area.damage



func _shoot_sparks():
	animationPlayer.play("Shoot2")
	attacking=true
	lastState="ShootSpark"

func _shoot_missiles():
	animationPlayer.play("Shoot1")
	attacking=true
	lastState="ShootMissile"


func _on_DeathTimer_timeout():
	self.Circle.queue_free()
	self.queue_free()
	emit_signal("dead")


func _on_DetectionZone_body_entered(body):
	if active==false&&body.name.match("X"):
		active=true
		$HitTimer.start(1)
		



func _on_Stats_zero_health():
	$Sprite.visible=false
	self.Circle=deatheffects.instance()
	self.Circle.position=self.global_position
	get_parent().add_child(Circle)
	$DeathTimer.start(0.6)
	self.collision.queue_free()
	$HurtBox/CollisionShape2D.queue_free()


func MissileFire():
	missile1=missile.instance()
	missile2=missile.instance()
	missile1.position=Missile1.global_position
	missile1.set_direction(-1)
	get_parent().add_child(missile1)
	missile2.position=Missile2.global_position
	missile2.set_direction(-1)
	get_parent().add_child(missile2)


func SparkFire():
	spark1=spark.instance()
	spark2=spark.instance()
	spark1.position=Spark1.global_position
	spark1.set_direction(-1)
	get_parent().add_child(spark1)
	spark2.position=Spark2.global_position
	spark2.set_direction(-1)
	get_parent().add_child(spark2)

func BackToIdle():
	animationPlayer.play("Idle")
	
func _on_HitTimer_timeout():
	if lastState=="ShootMissile":
		state="ShootSpark"
	else:
		state="ShootMissile"
	$HitTimer.start(2)
	attacking=false
