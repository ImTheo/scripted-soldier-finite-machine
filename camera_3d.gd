extends Camera3D


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			fov += 1
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			fov -= 1
	if event is InputEventKey:
		if event.is_action("c_down"):
			position.x -= 1
		if event.is_action("c_up"):
			position.x -= -1
		if event.is_action("c_right"):
			position.z -= -1
		if event.is_action("c_left"):
			position.z -= 1
			#elif event. == KEY_RIGHT:
			#elif event.pressed == KEY_LEFT:
				#position.x -= 1
