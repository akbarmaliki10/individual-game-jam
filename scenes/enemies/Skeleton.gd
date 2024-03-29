extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var endPoint: Marker2D

@onready var animations = $AnimatedSprite2D

var isDead: bool = false

var startPosition
var endPosition

func _ready():
	startPosition = position
	endPosition = endPoint.global_position
	animations.flip_h = false
	animations.play("idle")

func changeDirection():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized() * speed

func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
	else:
		if velocity.x < 0:
			#Left
			animations.flip_h = true
			animations.play("walk")
		elif velocity.x > 0:
			# Right
			animations.flip_h = false
			animations.play("walk")
		elif velocity.y > 0:
			animations.play("walk")
		elif velocity.y < 0:
			animations.play("walk")

func _physics_process(delta):
	if isDead: return
	
	updateVelocity()
	move_and_slide()
	updateAnimation()

func _on_hurt_box_area_entered(area):
	if area == $HitBox:
		return
	$HitBox.set_deferred("monitorable", false)
	isDead = true
	animations.play("death")
	$DeathSFX.play()
	await animations.animation_finished
	queue_free()
