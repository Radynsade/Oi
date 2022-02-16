extends Control

func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")

func _on_SettingsButton_pressed():
	pass # Replace with function body.

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_MultiplayerButton_pressed():
	pass # Replace with function body.
