extends Control

@onready var pressedSfx = $ButtonPressedSFX

func _on_start_pressed():
	pressedSfx.play()
	await pressedSfx.finished
	get_tree().change_scene_to_file("res://scenes/Village.tscn")


func _on_quit_pressed():
	pressedSfx.play()
	await pressedSfx.finished
	get_tree().quit()
