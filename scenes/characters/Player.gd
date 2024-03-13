extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var effects = $Effects

@onready var animationWeapon = $AnimationPlayer
@onready var animationAttack = $AnimatedAttack
var isAttacking: bool = false
@onready var weapon = $Weapon

@export var speed: int = 50

@export var maxHealth: int = 4
@onready var currentHealth: int = maxHealth

@onready var hurtBox = $HurtBox
@onready var hurtTimer = $HurtTimer
var isHurt: bool = false

@export var knockbackPower: int = 1000

signal healthChanged

var lastPlayerDirection: String = "Down"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func updateAnimation():
	if isAttacking:
		return
	if velocity.length() == 0:
		animation.stop()
	else:
		if velocity.x < 0:
			#Left
			animation.flip_h = false
			animation.play("side_walk")
			lastPlayerDirection = "left"
		elif velocity.x > 0:
			# Right
			animation.flip_h = true
			animation.play("side_walk")
			lastPlayerDirection = "right"
		elif velocity.y > 0:
			animation.play("down_walk")
			lastPlayerDirection = "down"
		elif velocity.y < 0:
			animation.play("up_walk")
			lastPlayerDirection = "up"
		
func _ready():
	animation.flip_h = true
	animation.play("side_idle")
	effects.play("RESET")

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed
	
	if Input.is_action_just_pressed("attack"):
		attack()
		

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

func _physics_process(delta):
	handleInput()
	move_and_slide()
	handleCollision()
	updateAnimation()
	
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "HitBox":
				hurtByEnemy(area)

func attack():
	if lastPlayerDirection == "down":
		animationWeapon.play("down_attack")
		animationAttack.play("down_attack")
	elif lastPlayerDirection == "up":
		animationWeapon.play("up_attack")
		animationAttack.play("up_attack")
	elif lastPlayerDirection == "right":
		animationWeapon.play("right_attack")
		animationAttack.flip_h = true
		animationAttack.play("side_attack")
	elif lastPlayerDirection == "left":
		animationWeapon.play("side_attack")
		animationAttack.flip_h = false
		animationAttack.play("side_attack")
	isAttacking = true
	weapon.enable()
	animationAttack.visible = true
	await  animationWeapon.animation_finished
	await  animationAttack.animation_finished
	weapon.disable()
	animationAttack.visible = false
	isAttacking = false

func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth < 1:
		currentHealth = maxHealth
		
	healthChanged.emit(currentHealth)
	isHurt = true
	knockback(area.get_parent().velocity)
		
	effects.play("hurtPlayer")
	hurtTimer.start()
	await  hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect()

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
