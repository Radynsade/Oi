extends Control

func _on_LeaveButton_pressed():
	if Network.client:
		Network.client.close_connection()
	
	if Network.server:
		Network.server.close_connection()
	
	Global.set_state(Global.STATES.MENUS)
