extends CharacterBody2D

@onready var animation = $AnimatedSprite2D

@export var speed: int = 50

@export var maxHealth: int = 4
@onready var currentHealth: int = maxHealth
const JUMP_VELOCITY = -400.0

signal healthChanged

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func updateAnimation():
	if velocity.length() == 0:
		animation.stop()
	else:
		if velocity.x < 0:
			#Left
			animation.flip_h = false
			animation.play("side_walk")
		elif velocity.x > 0:
			# Right
			animation.flip_h = true
			animation.play("side_walk")
		elif velocity.y > 0:
			animation.play("down_walk")
		elif velocity.y < 0:
			animation.play("up_walk")
		
func _ready():
	animation.flip_h = true
	animation.play("side_idle")

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()


func _on_hurt_box_area_entered(area):
	if area.name == "HitBox":
		currentHealth -= 1
		if currentHealth < 1:
			currentHealth = maxHealth
		
		healthChanged.emit(currentHealth)
