extends Control

@export_file("*.json") var dialogueFile

@onready var dialogueBox = $NinePatchRect
@onready var dialogueBoxName = $NinePatchRect/Name
@onready var dialogueBoxText = $NinePatchRect/Text
var isDialogueActive = false

signal dialogue_finished

var dialogue = []
var current_dialogue_id = 0

func _ready():
	dialogueBox.visible = false

func _input(event):
	if !isDialogueActive:
		return
	if event.is_action_pressed("ui_accept"):
		next_script()

func start():
	if isDialogueActive:
		return
	isDialogueActive = true
	dialogueBox.visible = true
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()

func  load_dialogue():
	var file = FileAccess.open(dialogueFile, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		isDialogueActive = false
		dialogueBox.visible = false
		dialogue_finished.emit()
		return
		
	dialogueBoxName.text = dialogue[current_dialogue_id]['name']
	dialogueBoxText.text = dialogue[current_dialogue_id]['text']
