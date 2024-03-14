extends HBoxContainer

@onready var HeartGUIClass = preload("res://gui/HeartGUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setMaxHearts(max :int):
	for i in range(max):
		var heart = HeartGUIClass.instantiate()
		add_child(heart)

func updateHearts(currentHealth: int):
	var hearts = get_children()
	
	if currentHealth < 1:
		$GameOverSFX.play()
		print_debug(currentHealth)
	
	for i in range(currentHealth):
		hearts[i].update(true)
	
	for i in range(currentHealth, hearts.size()):
		hearts[i].update(false)
