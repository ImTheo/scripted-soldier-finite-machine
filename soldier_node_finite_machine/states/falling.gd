extends SoldierState
var gravity = 0

func enter(previus_state_path)->void:
	soldier.show_state("faling")
	soldier.play_animation(SoldierFiniteMachineScripted.States.STANDING)

func physics_update(delta:float)->void:
	#print("falling")
	if soldier.is_on_floor():
		# (get_parent() as StateMachine)._transition_to_next_state(states[States.STANDING])
		finished.emit(states[States.STANDING])
	_handle_gravity(delta)
	soldier.move_and_slide()

func _handle_gravity(delta):
	gravity += 50 * delta
	soldier.velocity.y = -gravity
