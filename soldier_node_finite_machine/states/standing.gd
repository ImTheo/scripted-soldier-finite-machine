extends SoldierState

func enter(_previus_state_path)->void:
	soldier.show_state("standing")
	soldier.play_animation(SoldierFiniteMachineScripted.States.STANDING)

func physics_update(delta:float)->void:
	#print("standing")
	if not soldier.is_on_floor():
		# (get_parent() as StateMachine)._transition_to_next_state(states[States.FALING])
		finished.emit(states[States.FALING])
	elif soldier.is_control_pressed():
		# (get_parent() as StateMachine)._transition_to_next_state(states[States.WALKING])
		finished.emit(states[States.WALKING])
	elif soldier.has_collisions():
		# (get_parent() as StateMachine)._transition_to_next_state(states[States.SHOOTING])
		finished.emit(states[States.SHOOTING])
	elif soldier.health < 0:
		# (get_parent() as StateMachine)._transition_to_next_state(states[States.DYING])
		finished.emit(states[States.DYING])
