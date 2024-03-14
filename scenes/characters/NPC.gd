extends CharacterBody2D

const speed = 30

var currentState = IDLE

@onready var animations = $AnimatedSprite2D

var isRoaming = true
var isChatting = false

var direction = Vector2.RIGHT
var startPos

var player
var playerInChatZone = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	startPos = position
	
func _physics_process(delta):
	if currentState == 0 or currentState == 1:
		animations.play("idle")
	elif currentState == 2 and !isChatting:
		if direction.x == -1:
			animations.play("walk_west")
		if direction.x == 1:
			animations.play("walk_east")
		if direction.y == -1:
			animations.play("walk_north")
		if direction.y == 1:
			animations.play("walk_south")
			
	if isRoaming:
		match currentState:
			IDLE:
				pass
			NEW_DIR:
				direction = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
	if Input.is_action_just_pressed("chat"):
		print("chatting with npc")
		isRoaming = false
		isChatting = true
		animations.play("idle")
	
func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	if !isChatting:
		position += direction * speed * delta
		move_and_slide()
		
		


func _on_chat_detection_area_body_entered(body):
	if body.has_method("player"):
		player = body
		playerInChatZone = true


func _on_chat_detection_area_body_exited(body):
	if body.has_method("player"):
		playerInChatZone = false


func _on_timer_timeout():
	$Timer.wait_time = choose([0.5,1,1,1.5])
	currentState = choose([IDLE, NEW_DIR, MOVE])
