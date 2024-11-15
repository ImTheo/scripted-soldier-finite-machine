extends SoldierState
var movement_velocity
var rotation_direction: float

func enter(previus_state_path)->void:
	soldier.update_state_label("walking")
	soldier.play_animation(States.WALKING)

func physics_update(delta:float)->void:
	#print("walking")
	if not soldier.is_control_pressed():
		# (get_parent() as StateMachine)._transition_to_next_state(states[States.STANDING])
		finished.emit(states[States.STANDING])
	if not soldier.is_on_floor():
		# (get_parent() as StateMachine)._transition_to_next_state(states[States.FALLING])
		finished.emit(states[States.FALLING])
	elif soldier.has_collisions():
		# (get_parent() as StateMachine)._transition_to_next_state(states[States.SHOOTING])
		finished.emit(states[States.SHOOTING])
	elif soldier.health < 0:
		# (get_parent() as StateMachine)._transition_to_next_state(states[States.DYING])
		finished.emit(states[States.DYING])
	_handle_controls(delta)
	soldier.move_and_slide()

func _handle_controls(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis(soldier.controls[soldier.Controls.DOWN].action,soldier.controls[soldier.Controls.UP].action)
	input.z = Input.get_axis(soldier.controls[soldier.Controls.LEFT].action,soldier.controls[soldier.Controls.RIGHT].action)
	if input.length() > 1:
		input = input.normalized()
	movement_velocity = input * 500 * delta
	soldier.velocity = movement_velocity
	rotation_direction = Vector2(movement_velocity.z, movement_velocity.x).angle()
	soldier.rotation.y = lerp_angle(soldier.rotation.y, rotation_direction, delta*10)
