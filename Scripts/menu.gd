extends Control

signal resume

func _on_resume_pressed():
	resume.emit()

func _on_settings_pressed():
	pass # Replace with function body.


func _on_host_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
