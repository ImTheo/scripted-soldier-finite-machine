extends SoldierState

func enter(_previus_state_path)->void:
	soldier.show_state("shooting")
	soldier.play_animation(SoldierFiniteMachineScripted.States.SHOOTING)
	soldier.velocity = Vector3.ZERO

func physics_update(delta:float)->void:
	if not soldier.has_collisions():
		#(get_parent() as StateMachine)._transition_to_next_state(states[States.STANDING])
		finished.emit(states[States.STANDING])
	elif not soldier.is_on_floor():
		#(get_parent() as StateMachine)._transition_to_next_state(states[States.FALING])
		finished.emit(states[States.FALING])
	elif soldier.health < 0:
		#(get_parent() as StateMachine)._transition_to_next_state(states[States.DYING])
		finished.emit(states[States.DYING])
