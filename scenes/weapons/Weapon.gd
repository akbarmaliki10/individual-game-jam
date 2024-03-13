extends Node2D

var weapon: Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_children().is_empty(): return
# remove weapon shape because i just want to show the animation
	visible = false
	
	weapon = get_children()[0]
	
func enable():
	weapon.enable()

func disable():
	if !weapon: return
	weapon.disable()

