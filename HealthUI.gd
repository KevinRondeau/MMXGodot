extends Control

var health=32 setget set_health
var max_health=32 setget set_max_health

onready var LifeUIFull=$LifeUIFull
onready var LifeUIEmpty=$LifeUIEmpty

func set_health(value):
	health=clamp(value,0,max_health)
	if LifeUIFull!=null:
		LifeUIFull.rect_size.y=health*2
		LifeUIFull.rect_position.y=(max_health*2)-(health*2)+3
	
func set_max_health(value):
	max_health=max(value,1)
	if LifeUIEmpty!=null:
		LifeUIEmpty.rect_size.y=max_health*2
		LifeUIEmpty.rect_position.y=(max_health*2)-(health*2)+3
	
func _ready():
	self.max_health=PlayerStats.max_health
	self.health=PlayerStats.health
	PlayerStats.connect("health_changed",self,"set_health")
	PlayerStats.connect("max_health_changed",self,"set_max_health")
