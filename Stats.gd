extends Node

export(int) var max_health=1 setget set_max_health
var health=max_health setget set_health
var damage
var lifes=3

signal zero_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health=value
	self.health=min(health,max_health)
	emit_signal("max_health_changed")

func set_health(value):
	health=value
	emit_signal("health_changed",health)
	if health<=0:
		lifes-=1
		emit_signal("zero_health")
		

func _ready():
	self.health=max_health
