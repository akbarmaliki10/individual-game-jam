extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	anim.flip_h = true
	anim.play("side_idle")

func handleInput():
	var moveDirection = Input.get_vector("ui_right", "ui_left", "ui_up", "ui_down")
	velocity = moveDirection
