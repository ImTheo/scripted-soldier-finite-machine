extends SoldierState

func enter(previus_state_path)->void:
	soldier.update_state_label("standing")
	soldier.play_animation(States.STANDING)
	if previus_state_path == states[States.WALKING]:
		soldier.velocity = Vector3.ZERO

func physics_update(delta:float)->void:
	if not soldier.is_on_floor():
		finished.emit(states[States.FALLING])
	elif soldier.is_control_pressed():
		finished.emit(states[States.WALKING])
	elif soldier.has_collisions():
		finished.emit(states[States.SHOOTING])
	elif soldier.health < 0:
		finished.emit(states[States.DYING])
