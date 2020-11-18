extends KinematicBody2D
#Physics
export var SPEED=150
export var DASHSPEED=300
export var GRAVITY=40
export var MAXFALLSPEED=1000
export var JUMPFORCE=-2000

const FLOOR=Vector2(0,-1)
#Input&Facing
var input_vector=Vector2.ZERO
var velocity=Vector2.ZERO
var face_right
var actual_facing
var can_jump
var can_shoot
var can_dash;
var charge=0;
#preload scene to shoot bullet
const BULLET=preload("res://MegaManX/Bullet.tscn")
const FIRSTCHARGE=preload("res://MegaManX/FirstCharge.tscn")
const MAXCHARGE=preload("res://MegaManX/MaxCharge.tscn")
#preload Sounds
var SpawnFallSound=load("res://Assets/SFX/MMXSFX/Spawn.wav")
var SpawnSound=load("res://Assets/SFX/MMXSFX/Spawn2.wav")
var DashSound=load("res://Assets/SFX/MMXSFX/Dash.wav")
var JumpSound=load("res://Assets/SFX/MMXSFX/Jump.wav")
var ShootSound=load("res://Assets/SFX/MMXSFX/Shot.wav")
var ChargingSound=load("res://Assets/SFX/MMXSFX/ChargeSound.wav")
var Charge1Sound=load("res://Assets/SFX/MMXSFX/Charged1.wav")
var Charge2Sound=load("res://Assets/SFX/MMXSFX/Charged2.wav")
var WallKickSound=load( "res://Assets/SFX/MMXSFX/WallKick.wav")
var DeathSound=load("res://Assets/SFX/MMXSFX/XDeath.wav")
onready var States={
	"Spawn": $StateMachineX/SpawnX,
	"Idle" : $StateMachineX/IdleX,
	"Move" : $StateMachineX/MoveX,
	"Dash" : $StateMachineX/DashX,
	"Jump" : $StateMachineX/JumpX,
	"Fall" : $StateMachineX/FallX,
	"Shoot": $StateMachineX/ShootX,
	"WallGrab" : $StateMachineX/WallGrabX,
	"WallKick": $StateMachineX/WallKickX,
	"Dead" : $StateMachineX/DeadX
}
#OnReady Var
onready var animationPlayer=$AnimationPlayer
onready var fireTimer=$Firing
onready var shotTimer=$ShotTimer
onready var currentState=States.Spawn
onready var lastState="Idle"
onready var bullet
onready var jumpState="Move"
onready var currentAnimation=0.0
onready var FirstParticle=$FirstCharge
onready var FullParticle=$MaxCharge
onready var sprite=$Sprite
onready var IdleFire=$IdleFire
onready var RunFire=$RunFire
onready var JumpFire=$JumpFire
onready var DashFire=$DashFire
onready var SFX=$SFX
onready var Music=$Music
onready var Charge2=$Charge2
onready var Charge1=$Charge1
onready var Shot=$Shot
onready var ChargeSound=$ChargeSound


func _ready():
	sprite.scale.x*=-1
	IdleFire.position.x*=-1
	RunFire.position.x*=-1
	JumpFire.position.x*=-1
	DashFire.position.x*=-1
	face_right=true
	actual_facing=true
	can_dash=true
	Music.play(0.0);
	currentState._enter_state()
	SFX.stream=SpawnFallSound
	SFX.play(0.0)
	ChargeSound.stream=ChargingSound

func _physics_process(_delta):
	var update_state=currentState._handle_input()
	if update_state!=null:
		change_state(update_state);
		currentState._enter_state()
	if currentState!=States.Spawn:
		#Charge
		if Input.is_action_pressed("Attack"):
			charge+=1
		#ChargeEffect
		if charge>49:
			if !ChargeSound.is_playing():
				ChargeSound.play()
			if ChargeSound.get_playback_position()>2.8:
				ChargeSound.play(1.8)
				
			FirstParticle.emitting=true
			FirstParticle.visible=true
		if charge>145:
			if charge>150:
				charge=150
			FirstParticle.emitting=false
			FirstParticle.visible=false
			FullParticle.emitting=true
			FullParticle.visible=true
	#Facing
	if face_right!=actual_facing:
		sprite.scale.x*=-1
		IdleFire.position.x*=-1
		RunFire.position.x*=-1
		JumpFire.position.x*=-1
		DashFire.position.x*=-1
		actual_facing=face_right
	if currentState==States.WallGrab:
		velocity.y+=GRAVITY
		if(velocity.y>MAXFALLSPEED/4):
			velocity.y=MAXFALLSPEED/4
	else:
		velocity.y+=GRAVITY
		if(velocity.y>MAXFALLSPEED):
			velocity.y=MAXFALLSPEED


func change_state(new_state):
	currentState=States[new_state]
	

func fire():
	$FirstCharge.emitting=false
	$FirstCharge.visible=false
	$MaxCharge.emitting=false
	$MaxCharge.visible=false
	can_shoot=false
	if charge<50:
		Shot.play()
		fireTimer.start(0.3)
		$ShotTimer.start(0.1)
		bullet=BULLET.instance()
	elif charge>=50&&charge<150:
		Charge1.play()
		$ShotTimer.start(0.5)
		fireTimer.start(0.5)
		bullet=FIRSTCHARGE.instance()
	elif charge>=144:
		Charge2.play()
		$ShotTimer.start(0.5)
		fireTimer.start(0.5)
		bullet=MAXCHARGE.instance()
	if face_right==true:
		bullet.set_direction(1)
	else:
		bullet.set_direction(-1)
	ChargeSound.stop()
	bulletPosition()
	get_parent().add_child(bullet)
	charge=0

func bulletPosition():
	match lastState:
		"Idle":
			bullet.position=$IdleFire.global_position
		"Move":
			bullet.position=$RunFire.global_position
		"Jump":
			bullet.position=$JumpFire.global_position
		"Fall":
			bullet.position=$JumpFire.global_position
		"Dash":
			bullet.position=$DashFire.global_position

func shoot():
	currentAnimation=animationPlayer.current_animation_position
	match lastState:
		"Idle":
			animationPlayer.play("IdleFire")
			animationPlayer.seek(0)
			if input_vector!=Vector2.ZERO:
				shot_ended()
		"Move":
			animationPlayer.play("RunFire")
			animationPlayer.seek(currentAnimation)
		"Jump":
			animationPlayer.play("JumpFire")
			animationPlayer.seek(currentAnimation)
		"Fall":
			animationPlayer.play("JumpFire")
			animationPlayer.seek(0.8)
		"Dash":
			animationPlayer.play("DashFire")
			animationPlayer.seek(currentAnimation)
			
func _Spawned():
	currentState=States.Idle
	currentState._enter_state()
	can_shoot=true
	can_jump=true

func shot_ended():
	currentAnimation=animationPlayer.current_animation_position
	match lastState:
		"Idle":
			animationPlayer.play("Idle")
			currentState=States.Idle
			currentState._enter_state()
		"Move":
			animationPlayer.play("Run")
			animationPlayer.seek(currentAnimation)
			currentState=States.Move
			currentState._enter_state()
		"Jump":
			animationPlayer.play("Jump")
			animationPlayer.seek(currentAnimation)
			currentState=States.Jump
			currentState._enter_state()
		"Fall":
			animationPlayer.play("Jump")
			animationPlayer.seek(0.8)
			currentState=States.Fall
			currentState._enter_state()
		"Dash":
			animationPlayer.play("Dash")
			animationPlayer.seek(currentAnimation)
			currentState=States.Dash
			currentState._enter_state()
		
func _on_Firing_timeout():
	shot_ended()

func _on_ShotTimer_timeout():
	can_shoot=true
