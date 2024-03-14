extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5

@onready var animations = $AnimatedSprite2D

var isDead: bool = false


var playerChase = false
var player = null

func _ready():
	animations.flip_h = false
	animations.play("right_idle")

func _physics_process(delta):
	if isDead: return
	
	if playerChase:
		animations.play("right_walk")
		position += (player.position - position)/speed
		move_and_collide(Vector2(0,0))


func _on_hurt_box_area_entered(area):
	if area == $HitBox:
		return
	$HitBox.set_deferred("monitorable", false)
	isDead = true
	animations.play("death")
	await animations.animation_finished
	queue_free()


func _on_detection_area_body_entered(body):
	player = body
	playerChase = true


func _on_detection_area_body_exited(body):
	player = null
	animations.play("right_idle")
	playerChase = false
